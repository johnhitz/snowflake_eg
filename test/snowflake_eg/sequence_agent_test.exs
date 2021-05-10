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

    test "SnowflakeEg.SequenceAgent.update() increments value by 1" do
      child_spec = %{
        id: Seq,
        start: {SnowflakeEg.SequenceAgent, :start_link, [0, [name: Seq]]}
      }
      pid = start_supervised!(child_spec)
      SnowflakeEg.SequenceAgent.update(Seq)
      assert SnowflakeEg.SequenceAgent.get(Seq) == 1
      stop_supervised(pid)
    end

    test "SnowflakeEg.SequenceAgent.update() resets to 0 when sequence value is 999" do
      child_spec = %{
        id: Seq,
        start: {SnowflakeEg.SequenceAgent, :start_link, [999, [name: Seq]]}
      }
      pid = start_supervised!(child_spec)
      SnowflakeEg.SequenceAgent.update(Seq)
      assert SnowflakeEg.SequenceAgent.get(Seq) == 0
      stop_supervised(pid)
    end

    test "SnowflakeEg.SequenceAgent.update() returns 999 when sequence value is 998" do
      child_spec = %{
        id: Seq,
        start: {SnowflakeEg.SequenceAgent, :start_link, [998, [name: Seq]]}
      }
      pid = start_supervised!(child_spec)
      SnowflakeEg.SequenceAgent.update(Seq)
      assert SnowflakeEg.SequenceAgent.get(Seq) == 999
      stop_supervised(pid)
    end

  end
end
