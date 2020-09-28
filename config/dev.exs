use Mix.Config

config :ethereumex,
  client_type: :http,
  url: "http://localhost:8545"

config :rho,
  client: Rho.Client,
  abi_file: "networks/rho_abi.json",
  network_file: "networks/development.json"
