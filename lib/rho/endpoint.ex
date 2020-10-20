defmodule Rho.Endpoint do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts),
    do: Plug.Cowboy.http(__MODULE__, [], port: Application.fetch_env!(:rho, :port))

  match "/pending" do
    send_resp(conn, 200, Rho.Logs.get_pending_swaps() |> Jason.encode!())
  end

  match "/logs" do
    send_resp(conn, 200, Rho.Logs.get_logs() |> Jason.encode!())
  end

  match _ do
    send_resp(conn, 404, "Invalid Rho API Route")
  end
end
