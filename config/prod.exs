use Mix.Config

network = System.get_env("NETWORK")

config :ethereumex,
  client_type: :http,
  url: "https://#{network}-eth.compound.finance"

config :rho,
  client: Rho.Client,
  abi_file: "networks/rho_abi.json",
  network_file: "networks/#{network}.json"
