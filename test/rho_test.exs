defmodule RhoTest do
  use ExUnit.Case

  test "greets the world" do
    assert Rho.hello() == :world

    assert length(Rho.Logs.get_logs()) == 1
    assert Rho.Logs.get_pending_swaps() |> Map.keys() |> length == 1

    Rho.MockClient.bump_block_number()
    Rho.Worker.poll()
    assert length(Rho.Logs.get_logs()) == 2
    assert Rho.Logs.get_pending_swaps() |> Map.keys() |> length == 0
  end
end
