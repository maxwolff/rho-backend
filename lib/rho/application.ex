defmodule Rho.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Rho.Worker.start_link(arg)
      # {Rho.Worker, arg}
    ]

    ExW3.Contract.start_link()
    rhoAbi = ExW3.load_abi("networks/abis.json")
    ExW3.Contract.register(:Rho, abi: rhoAbi)
    ExW3.Contract.at(:Rho, "0x27D5F5d4754ED7528037Fa5A4cCe0Bf728bAeD41")
    {:ok, filter_id} = ExW3.Contract.filter(:Rho, "Supply", %{fromBlock: 0, toBlock: "latest"})
    IO.inspect(ExW3.Contract.get_filter_changes(filter_id))
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rho.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
