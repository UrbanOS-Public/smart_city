defmodule SmartCity.AccessGroup do
  @moduledoc """
  Struct defining an access group update event.

  ```javascript
  const AccessGroup = {
    "description": "",
    "name"": "",
    "id": ""
  }
  ```
  """
  @type t :: %SmartCity.AccessGroup{}
  @type id :: term()
  @type reason() :: term()

  @derive Jason.Encoder
  defstruct description: nil,
            id: nil,
            name: nil

  alias SmartCity.BaseStruct

  defmodule NotFound do
    defexception [:message]
  end

  @doc """
  Returns a new `SmartCity.AccessGroup` struct.

  Can be created from:
  - map with string keys
  - map with atom keys
  - JSON
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{id: _, name: _} = msg) do
    struct = struct(%__MODULE__{}, msg)

    {:ok, struct}
  end

  defp create(msg) do
    {:error, "Invalid access group: #{inspect(msg)}"}
  end
end
