defmodule RhoTest do
  use ExUnit.Case

  test "closes swap" do
    Rho.MockClient.set_block_number("0x1")
    Rho.Worker.poll()

    assert length(Rho.Logs.get_logs()) == 2
    assert Rho.Logs.get_pending_swaps() |> Map.keys() |> length == 2

    Rho.MockClient.set_block_number("0x2")
    Rho.Worker.poll()

    assert length(Rho.Logs.get_logs()) == 4
    assert Rho.Logs.get_pending_swaps() |> Map.keys() |> length == 0
  end
end
