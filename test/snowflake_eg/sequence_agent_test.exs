defmodule SnowflakeEg.SequenceAgentTest do
  use ExUnit.Case

  describe "tests SnowflakeEg.SequenceAgent" do
    test "SnowflakeEg.SequenceAgent.get() returns 0 on initial request after starting" do
      child_spec = %{
        id: Seq,
        start: {SnowflakeEg.SequenceAgent, :start_link, [0, [name: Seq]]}
      }
      pid = start_supervised!(child_spec)
      assert SnowflakeEg.SequenceAgent.get() == 0
      stop_supervised(pid)
    end
  end
end
