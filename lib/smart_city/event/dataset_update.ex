defmodule SmartCity.Event.DatasetUpdate do
  @moduledoc """
  Struct defining a dataset update event.  This is triggered when new datasets are put into the system or existing
  datasets are updated

  ```javascript
  const Dataset = {
    "id": "",                  // UUID
    "business": {              // Project Open Data Metadata Schema v1.1
      "dataTitle": "",       // user friendly (dataTitle)
      "description": "",
      "keywords": [""],
      "modifiedDate": "",
      "orgTitle": "",        // user friendly (orgTitle)
      "contactName": "",
      "contactEmail": "",
      "license": "",
      "rights": "",
      "homepage": "",
      "spatial": "",
      "temporal": "",
      "publishFrequency": "",
      "conformsToUri": "",
      "describedByUrl": "",
      "describedByMimeType": "",
      "parentDataset": "",
      "issuedDate": "",
      "language": "",
      "referenceUrls": [""],
      "categories": [""]
    },
    "technical": {
      "dataName": "",        // ~r/[a-zA-Z_]+$/
      "orgId": "",
      "orgName": "",         // ~r/[a-zA-Z_]+$/
      "systemName": "",      // ${orgName}__${dataName},
      "schema": [
        {
          "name": "",
          "type": "",
          "description": ""
        }
      ],
      "sourceUrl": "",
      "protocol": "",       // List of protocols to use. Defaults to nil. Can be [http1, http2]
      "authUrl": "",
      "sourceFormat": "",
      "sourceType": "",     // remote|stream|ingest|host
      "cadence": "",
      "sourceQueryParams": {
        "key1": "",
        "key2": ""
      },
      "transformations": [], // ?
      "validations": [],     // ?
      "sourceHeaders": {
        "header1": "",
        "header2": ""
      }
      "authHeaders": {
        "header1": "",
        "header2": ""
      }
    },
    "_metadata": {
      "intendedUse": [],
      "expectedBenefit": []
    }
  }
  ```
  """

  use SmartCity.Event.EventHelper
  alias SmartCity.Event.DatasetUpdate.Business
  alias SmartCity.Event.DatasetUpdate.Technical
  alias SmartCity.Helpers
  alias SmartCity.Event.DatasetUpdate.Metadata

  @type id :: term()
  @type t :: %SmartCity.Event.DatasetUpdate{
          version: String.t(),
          id: String.t(),
          business: SmartCity.Event.DatasetUpdate.Business.t(),
          technical: SmartCity.Event.DatasetUpdate.Technical.t(),
          _metadata: SmartCity.Event.DatasetUpdate.Metadata.t()
        }

  @derive Jason.Encoder
  defstruct version: "0.3", id: nil, business: nil, technical: nil, _metadata: nil

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

  def create(%{id: id, business: biz, technical: tech, _metadata: meta}) do
    struct =
      struct(%__MODULE__{}, %{
        id: id,
        business: Business.new(biz),
        technical: Technical.new(tech),
        _metadata: Metadata.new(meta)
      })

    {:ok, struct}
  rescue
    e -> {:error, e}
  end

  def create(%{id: id, business: biz, technical: tech}) do
    create(%{id: id, business: biz, technical: tech, _metadata: %{}})
  end

  def create(msg) do
    {:error, "Invalid registry message: #{inspect(msg)}"}
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

  defp to_dataset(%{} = map) do
    {:ok, dataset} = new(map)
    dataset
  end

  defp to_dataset(json) do
    json
    |> Jason.decode!()
    |> to_dataset()
  end

  defp ok(value), do: {:ok, value}
end
