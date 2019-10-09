defmodule SmartCity.Dataset do
  @moduledoc """
  Struct defining a dataset definition and functions for retrieving key elements
  of the dataset for handling.

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
      "systemName": ""      // ${orgName}__${dataName}
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
          technical: SmartCity.Dataset.Technical.t(),
          version: String.t()
        }

  @derive Jason.Encoder
  defstruct version: "0.4", id: nil, business: nil, technical: nil

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

  defp create(%{id: id, business: biz, technical: tech}) do
    struct =
      struct(%__MODULE__{}, %{
        id: id,
        business: Business.new(biz),
        technical: Technical.new(tech)
      })

    case return_errors(struct) do
      [] -> {:ok, struct}
      errors -> {:error, errors}
    end
  rescue
    e -> {:error, e}
  end

  defp return_errors(struct) do
    []
    |> add_to_list_if_false(is_valid_modified_date?(struct.business.modifiedDate), %{
      "business.modifiedDate" => "Not ISO8601 formatted"
    })
  end

  defp is_valid_modified_date?(modified_date) do
    if modified_date == "" do
      true
    else
      case DateTime.from_iso8601(modified_date) do
        {:ok, _, _} -> true
        {:error, _} -> false
      end
    end
  end

  defp add_to_list_if_false(list, condition, item_to_add) do
    if condition == false, do: [item_to_add] ++ list, else: list
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
