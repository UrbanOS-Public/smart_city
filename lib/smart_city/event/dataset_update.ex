defmodule SmartCity.Event.DatasetUpdate do
  @moduledoc """
  Struct defining a dataset update event.  This is triggered when new datasets are put into the system or existing
  datasets are updated

  ```javascript
  const Dataset = {
    "id": "",                  // UUID
    "business": {              // Project Open Data Metadata Schema v1.1
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
      "orgTitle": "",        // user friendly (orgTitle)
      "parentDataset": "",
      "publishFrequency": "",
      "referenceUrls": [""],
      "rights": "",
      "spatial": "",
      "temporal": ""
    },
    "technical": {
      "authHeaders": {"header1": "", "header2": ""}
      "authUrl": "",
      "cadence": "",
      "dataName": "",        // ~r/[a-zA-Z_]+$/
      "orgId": "",
      "orgName": "",         // ~r/[a-zA-Z_]+$/
      "protocol": "",       // List of protocols to use. Defaults to nil. Can be [http1, http2]
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
      "sourceType": "",     // remote|stream|ingest|host
      "sourceUrl": "",
      "systemName": "",      // ${orgName}__${dataName},
      "transformations": [], // ?
      "validations": [],     // ?
    },
    "_metadata": {
      "intendedUse": [],
      "expectedBenefit": []
    }
  }
  ```
  """

  alias SmartCity.Event.DatasetUpdate.Business
  alias SmartCity.Event.DatasetUpdate.Technical
  alias SmartCity.Event.DatasetUpdate.Metadata

  @type id :: term()
  @type t :: %SmartCity.Event.DatasetUpdate{
          business: SmartCity.Event.DatasetUpdate.Business.t(),
          id: String.t(),
          _metadata: SmartCity.Event.DatasetUpdate.Metadata.t(),
          technical: SmartCity.Event.DatasetUpdate.Technical.t(),
          version: String.t()
        }

  @derive Jason.Encoder
  defstruct version: "0.3", id: nil, business: nil, technical: nil, _metadata: nil

  alias SmartCity.Event.BaseEvent

  @doc """
  Returns a new `SmartCity.Event.DatasetUpdate` struct. `SmartCity.Event.DatasetUpdate.Business`,
  `SmartCity.Event.DatasetUpdate.Technical`, and `SmartCity.Event.DatasetUpdate.Metadata` structs will be created along the way.

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
    |> BaseEvent.new()
    |> create()
  end

  defp create(%{id: id, business: biz, technical: tech} = dataset_event) do
    struct =
      struct(%__MODULE__{}, %{
        id: id,
        business: Business.new(biz),
        technical: Technical.new(tech),
        _metadata: Metadata.new(Map.get(dataset_event, :_metadata, %{}))
      })

    {:ok, struct}
  rescue
    e -> {:error, e}
  end

  defp create(msg) do
    {:error, "Invalid DatasetUpdate event: #{inspect(msg)}"}
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
