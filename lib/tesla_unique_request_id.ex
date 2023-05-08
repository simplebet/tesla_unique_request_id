defmodule Tesla.Middleware.UniqueRequestId do
  @moduledoc """
  Takes the `:request_id` property from the Logger metadata and passes it on in a header.
  (defaults to `"x-request-id"`).
  ### Example usage
  ```
  defmodule MyClient do
    use Tesla
    plug Tesla.Middleware.RequestId, header_name: "x-transaction-id"
  end
  ```
  """

  alias Tesla
  alias UUID
  require Logger

  @behaviour Tesla.Middleware
  @header_name "x-request-id"

  @impl true
  def call(env, next, opts) do
    env
    |> add_unique_request_id(opts)
    |> Tesla.run(next)
  end

  defp add_unique_request_id(env, opts) do
    header_name = Keyword.get(opts, :header_name, @header_name)

    case Tesla.get_header(env, @header_name) do
      nil ->
        id = UUID.uuid1()
        Logger.metadata(tesla_request_id: id)
        Tesla.put_header(env, header_name, id)

      _id ->
        :ok
    end
  end
end
