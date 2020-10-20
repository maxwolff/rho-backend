defmodule Rho.MockClient do
  use Agent

  def start_link() do
    Agent.start_link(fn -> "0x0" end, name: __MODULE__)
  end

  def block_number() do
    Agent.get(__MODULE__, & &1)
  end

  def set_block_number(new_bn) do
    Agent.update(__MODULE__, fn _ -> new_bn end)
  end

  def get_logs(_opts) do
    mock_logs()
    |> Enum.filter(fn log ->
      log["blockNumber"] == block_number()
    end)
  end

  def process_logs(logs) do
    logs
  end

  defp mock_logs() do
    [
      %{
        "name" => "OpenSwap",
        "address" => "0x27d5f5d4754ed7528037fa5a4cce0bf728baed41",
        "blockNumber" => "0x1",
        "data" => %{
          "benchmarkIndexInit" => 1_000_000_090_000_000_000,
          "initBlock" => 9,
          "notionalAmount" => 1_000_000_000_000_000_000,
          "owner" => "0x79c3aC86723f51f8bc248690C4da58F9fF7dcdB7",
          "swapFixedRateMantissa" => 30_000_026_516,
          "swapHash" => "0x54dad373f85eb2ed4cb5555de48a37efdac1ecf0169e86744e991f4769a24835",
          "userCollateralCTokens" => 51_840_045,
          "userPayingFixed" => true
        }
      },
      %{
        "name" => "OpenSwap",
        "address" => "0x27d5f5d4754ed7528037fa5a4cce0bf728baed41",
        "blockNumber" => "0x1",
        "data" => %{
          "benchmarkIndexInit" => 1_000_000_090_000_000_000,
          "initBlock" => 9,
          "notionalAmount" => 1_000_000_000_000_000_000,
          "owner" => "0x99c3aC86723f51f8bc248690C4da58F9fF7dcdB7",
          "swapFixedRateMantissa" => 30_000_026_516,
          "swapHash" => "0x64dad373f85eb2ed4cb5555de48a37efdac1ecf0169e86744e991f4769a24835",
          "userCollateralCTokens" => 51_840_045,
          "userPayingFixed" => true
        }
      },
      %{
        "name" => "CloseSwap",
        "address" => "0x27D5F5d4754ED7528037Fa5A4cCe0Bf728bAeD41",
        "blockNumber" => "0x2",
        "data" => %{
          "swapHash" => "0x54dad373f85eb2ed4cb5555de48a37efdac1ecf0169e86744e991f4769a24835"
        }
      },
      %{
        "name" => "CloseSwap",
        "address" => "0x27D5F5d4754ED7528037Fa5A4cCe0Bf728bAeD41",
        "blockNumber" => "0x2",
        "data" => %{
          "swapHash" => "0x64dad373f85eb2ed4cb5555de48a37efdac1ecf0169e86744e991f4769a24835"
        }
      }
    ]
  end
end
