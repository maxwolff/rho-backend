defmodule Rho.MixProject do
  use Mix.Project

  def project do
    [
      app: :rho,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Rho.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:abi, "~> 0.1.8"},
      {:ethereumex, "~> 0.6.4"},
      {:exth_crypto, "~> 0.1.6"},
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
