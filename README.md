# Rho

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rho` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rho, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rho](https://hexdocs.pm/rho).




    ExW3.new_filter(%{
      address: Rho.Application.get(:rho_address),
      fromBlock: from,
      toBlock: latest
    })
    |> ExW3.get_filter_logs()
    |> Rho.Logs.add_events()
