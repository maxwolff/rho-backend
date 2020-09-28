defmodule Rho.Endpoint do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts),
    do: Plug.Adapters.Cowboy2.http(__MODULE__, [])

  forward("/bot", to: Rho.Router)

  match _ do
    send_resp(conn, 200, Rho.Logs.get_pending_swaps() |> Jason.encode!())
  end
end
