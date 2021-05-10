defmodule SnowflakeEgTest do
  use ExUnit.Case
  doctest SnowflakeEg

  test "greets the world" do
    assert SnowflakeEg.hello() == :world
  end
end
