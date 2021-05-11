defmodule GlobalId do
  @moduledoc """
  @moduledoc """
  GlobalId is a SnoflakeId clone that generates globaly unique ids.
  """

  @doc """
  The get_id function uses a timestamp in milliseconds, a node_id between 0 and 1023, and a sequence value
  between 0 and 999 to generate a unique id. The sequence number increments on each successive run of the function. The
  node_id insures that if another node creates an id at the same millisecond with the same sequence value both ids are unique.
  The sequence value insures that if the same node creates more than 1 id in a given millisecond those ids are all unique as
  well. Having a sequence value is important because each node can receive up to 100,000 request per second or 100 times per
  millisecond. As written the function is capable of generating over 120,000 Ids per second as shown by the benchee
  results bellow:

  Operating System: Linux
  CPU Information: Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
  Number of Available Cores: 8
  Available memory: 15.59 GB
  Elixir 1.10.3
  Erlang 23.0.2

  Benchmark suite executing with the following configuration:
  warmup: 2 s
  time: 5 s
  memory time: 0 ns
  parallel: 1
  inputs: none specified
  Estimated total run time: 7 s

  Benchmarking get_id...

  Name             ips        average  deviation         median         99th %
  get_id      124.29 K        8.05 μs   ±221.17%        7.04 μs       20.35 μs

  The failure case that I see is that the SequenceAgent could go down. I handle this by putting the SequenceAgent under
  supervision and by creating a 1 millisecond delay when it is started to ensure that the millisecond value has changed
  by the time the sequence value is available. The delay insures that the agent can not start
  counting with a sequence value that is bellow a previous sequence value for any given milliseconds. If the timestamp
  are received from a queue the last timestamp value could be held and requests with stale data could be rejected.

  ## Example
      iex> id1 = GlobalId.get_id()
      iex> id2 = GlobalId.get_id()
      iex> id1 != id2
      true
  """
  @spec get_id() :: non_neg_integer
  def get_id() do
    sequence = SnowflakeEg.SequenceAgent.get()
    |> Integer.to_string()

    SnowflakeEg.SequenceAgent.update()

    timestamp =
      timestamp()
      |> Integer.to_string()

      node_id = node_id()
      |> Integer.to_string()

    id =
      timestamp
      |> Kernel.<>(node_id)
      |> Kernel.<>(sequence)
      |> String.to_integer()
  end

  @spec node_id() :: non_neg_integer
  def node_id(), do: 441

  @doc """
  Used for benchmark and testing.
  """
  @spec timestamp() :: non_neg_integer
  def timestamp(), do: DateTime.utc_now() |> DateTime.to_unix(:millisecond)
end
