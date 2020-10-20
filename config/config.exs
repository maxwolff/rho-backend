use Mix.Config

import_config "#{Mix.env()}.exs"

port =
  case System.get_env("PORT") do
    nil ->
      8080

    a ->
      {result, _} = Integer.parse(a)
      result
  end

config :rho,
  port: port
