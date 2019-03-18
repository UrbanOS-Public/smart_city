defmodule SmartCity.Data do
  @moduledoc """
  Message struct shared amongst all SCOS microservices.
  """

  alias SmartCity.Data
  alias SmartCity.Data.Timing
  alias SmartCity.Helpers

  @derive Jason.Encoder
  @enforce_keys [:dataset_id, :payload, :_metadata, :operational]
  defstruct _metadata: %{org: nil, name: nil, stream: false},
            dataset_id: nil,
            payload: nil,
            operational: %{timing: []}

  @doc """
  Returns a new `SmartCity.Data` struct. `SmartCity.Data.Timing`
    structs will be created along the way.

  Can be created from:
  - map with string keys
  - map with atom keys
  - JSON

  ## Examples

  iex> SmartCity.Data.new(%{dataset_id: "a_guid", payload: "the_data", _metadata: %{org: "scos", name: "example"}, operational: %{timing: [%{app: "stuff", label: "sus", start_time: 5, end_time: 10}]}})
  {:ok, %SmartCity.Data{
    dataset_id: "a_guid",
    payload: "the_data",
    _metadata: %{org: "scos", name: "example"},
    operational: %{timing: [%SmartCity.Data.Timing{app: "stuff", end_time: 10, label: "sus", start_time: 5}]}
  }}
  """
  def new(msg) when is_binary(msg) do
    with {:ok, decoded} <- Jason.decode(msg, keys: :atoms) do
      new(decoded)
    end
  end

  def new(%{"dataset_id" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataset_id: dataset_id, operational: %{timing: timings}, payload: payload, _metadata: metadata}) do
    struct =
      struct(__MODULE__, %{
        dataset_id: dataset_id,
        payload: payload,
        _metadata: metadata,
        operational: %{timing: Enum.map(timings, &Timing.new/1)}
      })

    {:ok, struct}
  rescue
    e -> {:error, e}
  end

  def new(msg) do
    {:error, "Invalid data message: #{inspect(msg)}"}
  end

  @doc """
  Encodes `SmartCity.Data` into JSON. Typically used right before sending as a Kafka message.

  Returns a JSON string.

  ## Parameters
  - message: A `SmartCity.Data` that you want to encode
  """
  def encode(%__MODULE__{} = message) do
    Jason.encode(message)
  end

  @doc """
  Encodes `SmartCity.Data` into JSON. Typically used right before sending as a Kafka message.

  Returns a JSON string.

  ## Parameters
  - message: A `SmartCity.Data` that you want to encode
  """
  def encode!(%__MODULE__{} = message) do
    Jason.encode!(message)
  end

  @doc """
  Adds a `SmartCity.Data.Timing` to the list of timings in this Data. The timing will be validated to ensure both start and end times have been set.

  Returns a `%SmartCity.Data` struct with `new_timing` prepended to timings already in the Data.

  ## Parameters
  - message: A `SmartCity.Data`
  - new_timing: A timing you want to add. Must have `start_time` and `end_time` set
  """
  def add_timing(
        %__MODULE__{operational: %{timing: timing}} = message,
        %Data.Timing{} = new_timing
      ) do
    case Timing.validate(new_timing) do
      {:ok, new_timing} -> put_in_operational(message, :timing, [new_timing | timing])
      {:error, errors} -> raise ArgumentError, "Invalid Timing: #{errors}"
    end
  end

  @doc """
  Creates a new `SmartCity.Data` struct using new/1 and adds timing information to the message.

  Returns a `%SmartCity.Data` struct with `new_timing` prepended to timings already in the Data.

  ## Parameters
  - message: A `SmartCity.Data`
  - app: The application that is asking to create the new `SmartCity.Data`. Ex. `reaper` or `voltron`
  """
  def timed_new(msg, app) do
    label = inspect(&Data.new/1)

    case Timing.measure(app, label, fn -> new(msg) end) do
      {:ok, msg, timing} -> {:ok, msg |> add_timing(timing)}
      error -> error
    end
  end

  @doc """
  Transforms the `SmartCity.Data.payload` field with the given unary function and replaces it in the message.

  Additionally, returns a `%SmartCity.Data` struct with `new_timing` prepended to timings already in the Data.

  ## Parameters
  - message: A `SmartCity.Data`
  - app: The application that is asking to create the new `SmartCity.Data`. Ex. `reaper` or `voltron`
  - function: a /1 function that will transform the payload in the provided message
  """
  def timed_transform(%Data{} = msg, app, function) when is_function(function, 1) do
    label = inspect(function)

    case Timing.measure(app, label, fn -> function.(msg.payload) end) do
      {:ok, result, timing} -> {:ok, msg |> add_timing(timing) |> Map.replace!(:payload, result)}
      error -> error
    end
  end

  @doc """
  Get all timings on this Data

  Returns a list of  `%SmartCity.Data.Timing{}` structs or `[]`

  ## Parameters
  - data_message: The message to extract timings from
  """
  def get_all_timings(%__MODULE__{operational: %{timing: timing}}), do: timing

  # Private functions
  defp put_in_operational(%__MODULE__{operational: operational} = message, key, value) do
    %{message | operational: Map.put(operational, key, value)}
  end
end
