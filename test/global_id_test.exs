defmodule GobalIdTest do
  use ExUnit.Case
  doctest GlobalId

  describe "tests GlogalId" do
    test "tests GlobalId generates unique id in the event that sequece_agent restarts" do
      SnowflakeEg.SequenceAgent.update()
      SnowflakeEg.SequenceAgent.update()
      pid = Process.whereis(SnowflakeEg.SequenceAgent)
      id = GlobalId.get_id()

      Process.exit(pid, :kill)
      :timer.sleep(3)

      assert id != GlobalId.get_id()
    end

    test "test GlobalId can generate 1001 unique ids" do
      list = Enum.map(0..1000, fn(x) ->
        GlobalId.get_id()
      end)
      assert Enum.count(list) == Enum.count(Enum.uniq(list))
    end
  end
end
