defmodule RhoTest do
  use ExUnit.Case

  test "greets the world" do
    assert Rho.hello() == :world
    IO.inspect(Rho.Logs.get_events())
  end
end
