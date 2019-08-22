defmodule SmartCity.Event.OrganizationUpdate do
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
  @type t :: %SmartCity.Event.OrganizationUpdate{}
  @type id :: term()
  @type reason() :: term()

  @derive Jason.Encoder
  defstruct description: nil,
            dn: nil,
            homepage: nil,
            id: nil,
            logoUrl: nil,
            orgName: nil,
            orgTitle: nil,
            version: "0.1"

  alias SmartCity.Event.BaseEvent

  defmodule NotFound do
    defexception [:message]
  end

  @doc """
  Returns a new `SmartCity.Event.OrganizationUpdate` struct.

  Can be created from:
  - map with string keys
  - map with atom keys
  - JSON
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) do
    BaseEvent.new(msg)
    |> create()
  end

  @spec create(String.t() | map()) :: {:ok, SmartCity.Event.OrganizationUpdate.t()} | {:error, term()}
  defp create(%{id: _, orgName: _, orgTitle: _} = msg) do
    struct = struct(%__MODULE__{}, msg)

    {:ok, struct}
  end

  defp create(msg) do
    {:error, "Invalid organization message: #{inspect(msg)}"}
  end
end
