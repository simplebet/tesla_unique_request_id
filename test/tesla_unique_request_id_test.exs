defmodule TeslaUniqueRequestIdTest do
  use ExUnit.Case
  alias Tesla.Env

  @middleware Tesla.Middleware.UniqueRequestId

  test "with a request_id, it adds a header" do
    assert {:ok, env} = @middleware.call(%Env{headers: [{"authorization", "secret"}]}, [], [])
    assert Enum.any?(env.headers, fn {header, _value} -> "x-request-id" == header end)
  end

  test "using a custom header name" do
    assert {:ok, env} =
             @middleware.call(
               %Env{headers: [{"authorization", "secret"}]},
               [],
               header_name: "x-transaction-id"
             )

    assert Enum.any?(env.headers, fn {header, _value} -> "x-transaction-id" == header end) == true
  end
end
