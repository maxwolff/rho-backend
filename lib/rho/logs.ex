defmodule Rho.Worker do
  use GenServer

  @delay_ms 5000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    client().start_link()
    schedule_work()
    {:ok, []}
  end

  def client() do
    Application.fetch_env!(:rho, :client)
  end

  def schedule_work() do
    poll()
    Process.send_after(self(), :poll, @delay_ms)
  end

  def handle_info(:poll, state) do
    schedule_work()
    {:noreply, state}
  end

  def poll() do
    last_block = Rho.Logs.get_last_block()
    to_block = client().block_number()
    IO.puts("polling #{last_block} to #{to_block}")

    if last_block != to_block do
      client().get_logs(%{fromBlock: last_block, toBlock: to_block})
      |> client().process_logs()
      |> Rho.Logs.add_logs()

      Rho.Logs.update_last_block(to_block)
    end
  end
end

defmodule Rho.Logs do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{pending_swaps: %{}, logs: [], last_block: "0x0"} end,
      name: __MODULE__
    )
  end

  def add_logs(logs) do
    Enum.each(logs, fn log ->
      sanitized_data = for {k, v} <- log["data"], into: %{}, do: {k, to_string(v)}
      clean_log = %{log | "data" => sanitized_data}
      Agent.update(__MODULE__, &Map.update!(&1, :logs, fn x -> x ++ [clean_log] end))

      case log["name"] do
        "OpenSwap" ->
          Agent.update(
            __MODULE__,
            &put_in(&1, [:pending_swaps, log["data"]["swapHash"]], clean_log)
          )

        "CloseSwap" ->
          Agent.update(
            __MODULE__,
            &(pop_in(&1, [:pending_swaps, log["data"]["swapHash"]]) |> elem(1))
          )

        _ ->
          nil
      end
    end)
  end

  def get_logs() do
    Agent.get(__MODULE__, &Map.get(&1, :logs))
  end

  def get_pending_swaps() do
    Agent.get(__MODULE__, &Map.get(&1, :pending_swaps))
  end

  def update_last_block(block) do
    Agent.update(__MODULE__, &Map.put(&1, :last_block, block))
  end

  def get_last_block() do
    Agent.get(__MODULE__, &Map.get(&1, :last_block))
  end
end
