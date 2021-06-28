defmodule SmartCity.Organization do
  @moduledoc """
  Struct defining an organization update event.

  ```javascript
  const Organization = {
    "description": "",
    "dn": "",          // LDAP distinguished name
    "homepage": "",
    "id": "",          // uuid
    "logoUrl": "",
    "orgName": "",     // system friendly
    "orgTitle": ""     // user friendly
  }
  ```
  """
  @type t :: %SmartCity.Organization{}
  @type id :: term()
  @type reason() :: term()

  @derive Jason.Encoder
  defstruct description: nil,
            dn: nil,
            dataJsonUrl: nil,
            homepage: nil,
            id: nil,
            logoUrl: nil,
            orgName: nil,
            orgTitle: nil,
            version: "0.1"

  use Accessible

  alias SmartCity.BaseStruct

  defmodule NotFound do
    defexception [:message]
  end

  @doc """
  Returns a new `SmartCity.Organization` struct.

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

  defp create(%{id: _, orgName: _, orgTitle: _} = msg) do
    struct = struct(%__MODULE__{}, msg)

    {:ok, struct}
  end

  defp create(msg) do
    {:error, "Invalid organization: #{inspect(msg)}"}
  end
end

defimpl Brook.Deserializer.Protocol, for: SmartCity.Organization do
  def deserialize(_struct, data) do
    SmartCity.Organization.new(data)
  end
end
