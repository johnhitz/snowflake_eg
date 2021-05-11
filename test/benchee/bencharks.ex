defmodule Test.Benchee.Benchamrks do
  Benchee.run(
    %{
      "get_id" => fn -> GlobalId.get_id() end
    }
  )
end
