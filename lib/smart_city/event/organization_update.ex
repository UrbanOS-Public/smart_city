defmodule SmartCity.Event.OrganizationUpdate do
  @moduledoc """
  Struct defining an organization definition and functions for reading and writing organization definitions to Redis.

  ```javascript
  const Organization = {
    "id": "",          // uuid
    "orgTitle": "",    // user friendly
    "orgName": "",     // system friendly
    "description": "",
    "logoUrl": "",
    "homepage": "",
    "dn": ""           // LDAP distinguished name
  }
  ```
  """
  use SmartCity.Event.EventHelper
  alias SmartCity.Helpers

  @type t :: %SmartCity.Event.OrganizationUpdate{}
  @typep id :: term()
  @typep reason() :: term()

  @derive Jason.Encoder
  defstruct version: "0.1", id: nil, orgTitle: nil, orgName: nil, description: nil, logoUrl: nil, homepage: nil, dn: nil

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
  @spec create(String.t() | map()) :: {:ok, SmartCity.Event.OrganizationUpdate.t()} | {:error, term()}
  def create(%{id: _, orgName: _, orgTitle: _} = msg) do
    struct = struct(%__MODULE__{}, msg)

    {:ok, struct}
  end

  def create(msg) do
    {:error, "Invalid organization message: #{inspect(msg)}"}
  end
end
