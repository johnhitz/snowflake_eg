defmodule SnowflakeEg.SequenceAgent do
  use Agent

  @moduledoc """
  Generates a sequene of numbers between 0 and 999
  """
  def start_link(init, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    #sleep for 1 millisecond to insure unique timestamp on restart of SequenceAgent
    :timer.sleep(1)
    Agent.start_link(fn() -> init end, name: name)
  end

  def get(name \\ __MODULE__) do
    Agent.get(name, fn(val) -> val end)
  end

  def update(name \\ __MODULE__) do
    Agent.update(name, fn(val) -> val + 1 end)
  end
end
