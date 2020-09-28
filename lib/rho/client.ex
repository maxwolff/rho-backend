## A wrapper around Ethreumex that handles event encoding and decoding
defmodule Rho.Client do
  use Agent

  def block_number() do
    {:ok, bn} = Ethereumex.HttpClient.eth_block_number()
    bn
  end

  def get_event_data_sig(non_indexed_types, name) do
    "#{name}(#{Enum.join(non_indexed_types, ",")})"
  end

  def get_event_topic(abi) do
    all_types = Enum.map(abi["inputs"], &Map.get(&1, "type"))
    fn_sig = Enum.join([abi["name"], "(", Enum.join(all_types, ","), ")"])
    Enum.join(["0x", ExthCrypto.Hash.Keccak.kec(fn_sig) |> Base.encode16(case: :lower)], "")
  end

  def start_link() do
    rho_address =
      Application.fetch_env!(:rho, :network_file)
      |> File.read!()
      |> Jason.decode!()
      |> Access.get("rho")

    rho_abi =
      Application.fetch_env!(:rho, :abi_file)
      |> File.read!()
      |> Jason.decode!()

    events =
      Enum.filter(rho_abi, fn x ->
        x["type"] == "event"
      end)

    event_sig_to_info =
      Map.new(events, fn event ->
        indexed_fields =
          Enum.filter(event["inputs"], fn input ->
            input["indexed"]
          end)

        indexed_types =
          Enum.map(indexed_fields, fn field ->
            field["type"]
          end)

        indexed_names =
          Enum.map(indexed_fields, fn field ->
            field["name"]
          end)

        non_indexed_fields =
          Enum.filter(event["inputs"], fn input ->
            input["indexed"] == false
          end)

        non_indexed_types =
          Enum.map(non_indexed_fields, fn field ->
            field["type"]
          end)

        non_indexed_names =
          Enum.map(non_indexed_fields, fn field ->
            field["name"]
          end)

        topic = get_event_topic(event)

        {topic,
         %{
           name: event["name"],
           data_signature: get_event_data_sig(non_indexed_types, event["name"]),
           indexed_types: indexed_types,
           non_indexed_names: non_indexed_names,
           indexed_names: indexed_names
         }}
      end)

    Agent.start_link(
      fn -> %{rho_address: rho_address, event_sig_to_info: event_sig_to_info} end,
      name: __MODULE__
    )
  end

  def decode_event(data, signature) do
    formatted_data =
      data
      |> String.slice(2..-1)
      |> Base.decode16!(case: :lower)

    fs = ABI.FunctionSelector.decode(signature)

    ABI.TypeDecoder.decode(formatted_data, fs)
  end

  def decode_data(type, data) do
    {:ok, trim_data} = String.slice(data, 2..String.length(data)) |> Base.decode16(case: :lower)

    "(#{type})"
    |> ABI.decode(trim_data)
    |> List.first()
    |> Base.encode16(case: :lower)
    |> (&"0x#{&1}").()
  end

  def process_logs(logs) do
    Enum.map(logs, fn log ->
      [event_topic | data_topics] = log["topics"]

      info = Agent.get(__MODULE__, &(Map.get(&1, :event_sig_to_info) |> Map.get(event_topic)))

      non_indexed_data =
        decode_event(log["data"], info.data_signature)
        |> (&Enum.zip(info.non_indexed_names, &1)).()

      indexed_data =
        Enum.zip(info.indexed_types, data_topics)
        |> Enum.map(fn {type, data} -> decode_data(type, data) end)
        |> (&Enum.zip(info.indexed_names, &1)).()

      data = Enum.concat(non_indexed_data, indexed_data) |> Enum.into(%{})

      log
      |> Map.put("name", info.name)
      |> Map.put("data", data)
    end)
  end

  def get_logs(%{fromBlock: from, toBlock: to}) do
    {:ok, logs} =
      Ethereumex.HttpClient.eth_get_logs(%{
        fromBlock: from,
        toBlock: to,
        address: Agent.get(__MODULE__, &Map.get(&1, :rho_address))
      })

    logs
  end
end
