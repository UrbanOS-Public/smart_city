defmodule SmartCity.Ingestion do
  require Logger

  alias SmartCity.Helpers
  alias SmartCity.Ingestion.Transformation

  @moduledoc """
  Struct defining an ingestion update event.

  ```javascript
  const Ingestion = {
    "id": "",
    "name", "",
    "allow_duplicates": boolean,
    "cadence": "",
    "extractSteps": [],
    "schema": [],
    "targetDatasets": ["", ""],
    "sourceFormat": "",
    "topLevelSelector": "",
    "transformations": [],
  }
  ```
  """
  @type not_required(type) :: type | nil

  @type t :: %SmartCity.Ingestion{
          id: String.t(),
          name: String.t(),
          allow_duplicates: not_required(boolean()),
          cadence: not_required(String.t()),
          extractSteps: list(map()),
          schema: list(map()),
          sourceFormat: String.t(),
          targetDatasets: list(String.t()),
          topLevelSelector: not_required(String.t()),
          transformations: list(Transformation.t())
        }

  @derive Jason.Encoder
  defstruct id: nil,
            name: nil,
            allow_duplicates: true,
            cadence: "never",
            extractSteps: [],
            schema: [],
            targetDatasets: [],
            sourceFormat: nil,
            topLevelSelector: nil,
            transformations: []

  use Accessible

  @doc """
  Returns a new `SmartCity.Ingestion`.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input

  ## Parameters

  - msg: Map with string or atom keys that defines the ingestion metadata

  Required Keys:
      - targetDatasets
      - sourceFormat
      - name

  - cadence will default to "never"
  - allow_duplicates will default to true
  """
  @spec new(map()) :: SmartCity.Ingestion.t()
  def new(%{"targetDatasets" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(
        %{
          id: _,
          name: _,
          targetDatasets: _,
          sourceFormat: type,
          schema: schema,
          extractSteps: extractSteps,
          transformations: transformations
        } = msg
      ) do
    msg
    |> Map.put(:schema, Helpers.to_atom_keys(schema))
    |> Map.put(:extractSteps, Helpers.to_atom_keys(extractSteps))
    |> Map.put(:transformations, Enum.map(transformations, &Transformation.new/1))
    |> Map.replace!(:sourceFormat, Helpers.mime_type(type))
    |> create()
  end

  def new(%{targetDataset: targetDataset} = msg) do
    Logger.error(
      "Legacy ingestion detected. targetDataset field was used instead of targetDatasets. This field is deprecated to be removed after June 2023."
    )

    msg
    |> Map.put(:targetDatasets, [targetDataset])
    |> Map.delete(:targetDataset)
    |> new()
  end

  def new(msg) do
    raise ArgumentError, "Invalid ingestion metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
