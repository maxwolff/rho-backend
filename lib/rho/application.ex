defmodule Rho.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Rho.Logs,
      Rho.Worker
    ]

    opts = [strategy: :one_for_one, name: Rho.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
