defmodule SmartCity.EventLog do
  require Logger

  alias SmartCity.Helpers

  @moduledoc """
  Struct defining an event log event.

  ```javascript
  const EventLog = {
    "title": "",
    "timestamp", "",
    "source": "",
    "description": "",
    "dataset_id": ""
  }
  ```
  """
  @type not_required(type) :: type | nil

  @type t :: %SmartCity.EventLog{
               title: String.t(),
               timestamp: String.t(),
               source: String.t(),
               description: String.t(),
               dataset_id: not_required(String.t()), # Making dataset_id not required under the assumption that event log may be used for events not associated with a dataset (like organization updates)
               ingestion_id: not_required(String.t())
             }

  @derive Jason.Encoder
  defstruct title: nil,
            timestamp: nil,
            source: nil,
            description: nil,
            dataset_id: nil,
            ingestion_id: nil

  use Accessible

  @doc """
  Returns a new `SmartCity.EventLog`.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input

  ## Parameters

  - msg: Map with string or atom keys that defines the event log metadata

  Required Keys:
      - title
      - timestamp
      - source
      - description
      - dataset_id
      - ingestion_id
  """

  @spec new(map()) :: SmartCity.EventLog.t()
  def new(%{"title" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  @spec new(map()) :: SmartCity.EventLog.t()
  def new(
        %{
          title: _title,
          timestamp: _timestamp,
          source: _source,
          description: _description
        } = msg
      ) do
    create(msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid event log metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
