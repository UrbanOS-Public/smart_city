defmodule SmartCity.Dataset do
  @moduledoc """
  Struct defining a dataset definition and functions for retrieving key elements
  of the dataset for handling.

  ```javascript
  const Dataset = {
    "id": "",                // UUID
    "business": {            // Project Open Data Metadata Schema v1.1
      "authorEmail": "",
      "authorName": "",
      "benefitRating": 0,    // value between 0.0 and 1.0
      "categories": [""],
      "conformsToUri": "",
      "contactEmail": "",
      "contactName": "",
      "dataTitle": "",       // user friendly (dataTitle)
      "describedByMimeType": "",
      "describedByUrl": "",
      "description": "",
      "homepage": "",
      "issuedDate": "",
      "keywords": [""],
      "language": "",
      "license": "",
      "modifiedDate": "",
      "parentDataset": "",
      "publishFrequency": "",
      "referenceUrls": [""],
      "rights": "",
      "riskRating": 0,       // value between 0.0 and 1.0
      "spatial": "",
      "temporal": ""
    },
    "technical": {
      "allow_duplicates": true
      "authHeaders": {"header1": "", "header2": ""}
      "authBody": {"name": "", "clientID": ""}
      "authBodyEncodeMethod": "",
      "authUrl": "",
      "cadence": "",
      "dataName": "",        // ~r/[a-zA-Z_]+$/
      "protocol": "",        // List of protocols to use. Defaults to nil. Can be [http1, http2]
      "schema": [{
        "name": "",
        "type": "",
        "description": ""
      }],
      "sourceFormat": "",
      "sourceHeaders": {
        "header1": "",
        "header2": ""
      },
      "sourceQueryParams": {
        "key1": "",
        "key2": ""
      },
      "sourceType": "",      // remote|stream|ingest|host
      "sourceUrl": "",
      "systemName": "",      // ${orgName}__${dataName}
      "topLevelSelector": ""
    }
  }
  ```
  """

  alias SmartCity.Dataset.Business
  alias SmartCity.Dataset.Technical

  @type id :: term()
  @type t :: %SmartCity.Dataset{
          business: SmartCity.Dataset.Business.t(),
          id: String.t(),
          organization_id: String.t(),
          technical: SmartCity.Dataset.Technical.t(),
          version: String.t()
        }

  @derive Jason.Encoder
  defstruct version: "0.6", id: nil, business: nil, technical: nil, organization_id: nil

  use Accessible

  alias SmartCity.BaseStruct

  @doc """
  Returns a new `SmartCity.Dataset` struct. `SmartCity.Dataset.Business` and
  `SmartCity.Dataset.Technical` structs will be created along the way.

  ## Parameters

  - msg : map defining values of the struct to be created.
    Can be initialized by
    - map with string keys
    - map with atom keys
    - JSON
  """

  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) do
    msg
    |> BaseStruct.new()
    |> create()
  end

  defp create(%{id: id, business: biz, technical: tech, organization_id: organization_id}) do
    struct =
      struct(%__MODULE__{}, %{
        id: id,
        organization_id: organization_id,
        business: Business.new(biz),
        technical: Technical.new(tech)
      })

    {:ok, struct}
  rescue
    e -> {:error, e}
  end

  defp create(%{id: id, business: biz, technical: %{orgId: org_id} = tech}) do
    struct =
      struct(%__MODULE__{}, %{
        id: id,
        organization_id: org_id,
        business: Business.new(biz),
        technical: Technical.new(tech)
      })

    {:ok, struct}
  rescue
    e -> {:error, e}
  end

  defp create(msg) do
    {:error, "Invalid Dataset: #{inspect(msg)}"}
  end

  @doc """
  Returns true if `SmartCity.Dataset.Technical sourceType field is stream`
  """
  def is_stream?(%__MODULE__{technical: %{sourceType: sourceType}}) do
    "stream" == sourceType
  end

  @doc """
  Returns true if `SmartCity.Dataset.Technical sourceType field is remote`
  """
  def is_remote?(%__MODULE__{technical: %{sourceType: sourceType}}) do
    "remote" == sourceType
  end

  @doc """
  Returns true if `SmartCity.Dataset.Technical sourceType field is ingest`
  """
  def is_ingest?(%__MODULE__{technical: %{sourceType: sourceType}}) do
    "ingest" == sourceType
  end

  @doc """
  Returns true if `SmartCity.Dataset.Technical sourceType field is host`
  """
  def is_host?(%__MODULE__{technical: %{sourceType: sourceType}}) do
    "host" == sourceType
  end
end

defimpl Brook.Deserializer.Protocol, for: SmartCity.Dataset do
  def deserialize(_struct, data) do
    SmartCity.Dataset.new(data)
  end
end
