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
    "dataset_id": "",
    "ingestion_id": ""
  }
  ```
  """
  @type not_required(type) :: type | nil

  @type t :: %SmartCity.EventLog{
               title: String.t(),
               timestamp: DateTime.t(),
               source: String.t(),
               description: String.t(),
               dataset_id: String.t(),
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
          timestamp: "",
        } = msg
      ) do

    Map.put(msg, :timestamp, DateTime.to_iso8601(DateTime.utc_now()))
    |> create()
  end

  @spec new(map()) :: SmartCity.EventLog.t()
  def new(
        %{
          title: _title,
          timestamp: %DateTime{},
          source: _source,
          description: _description,
          dataset_id: _dataset_id
        } = msg
      ) do

    Map.put(msg, :timestamp, DateTime.to_iso8601(msg.timestamp))
    |> create()
  end

  @spec new(map()) :: SmartCity.EventLog.t()
  def new(
        %{
          title: _title,
          timestamp: timestamp,
          source: _source,
          description: _description,
          dataset_id: _dataset_id
        } = msg
      ) do
    case DateTime.from_iso8601(timestamp) do
      {:ok, _, _} -> create(msg)
      {:error, _} -> raise ArgumentError, "Invalid timestamp in event_log: #{timestamp}. Expected ISO8601 string format"
    end

  end

  def new(msg) do
    raise ArgumentError, "Invalid event log metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
