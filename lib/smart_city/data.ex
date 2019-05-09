defmodule SmartCity.Data do
  @moduledoc """
  Message struct shared amongst all SmartCity microservices.

  ```javascript
  const DataMessage = {
      "dataset_id": "",        // UUID
      "payload": {},
      "_metadata": {           // cannot be used safely
          "orgName": "",       // ~r/^[a-zA-Z_]+$/
          "dataName": "",      // ~r/^[a-zA-Z_]+$/
          "stream": true
      },
      "operational": {
          "timing": [{
              "startTime": "", // iso8601
              "endTime": "",   // iso8601
              "app": "",       // microservice generating timing data
              "label": ""      // label for this particular timing data
          }]
      }
  }
  ```
  """

  alias SmartCity.Data
  alias SmartCity.Data.Timing
  alias SmartCity.Helpers

  @type t :: %SmartCity.Data{
          :dataset_id => String.t(),
          :operational => %{
            :timing => list(SmartCity.Data.Timing.t())
          },
          :payload => String.t(),
          :_metadata => %{
            :org => String.t(),
            :name => String.t(),
            :stream => boolean()
          },
          :version => String.t()
        }
  @type payload :: String.t()

  @derive Jason.Encoder
  @enforce_keys [:dataset_id, :payload, :_metadata, :operational]
  defstruct version: "0.1",
            _metadata: %{org: nil, name: nil, stream: false},
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

      iex> SmartCity.Data.new(%{dataset_id: "a_guid", payload: "the_data", _metadata: %{org: "scos", name: "example"}, operational: %{timing: [%{app: "app name", label: "function name", start_time: "2019-05-06T19:51:41+00:00", end_time: "2019-05-06T19:51:51+00:00"}]}})
      {:ok, %SmartCity.Data{
          dataset_id: "a_guid",
          payload: "the_data",
          _metadata: %{org: "scos", name: "example"},
          operational: %{
          timing: [%SmartCity.Data.Timing{ app: "app name", end_time: "2019-05-06T19:51:51+00:00", label: "function name", start_time: "2019-05-06T19:51:41+00:00"}]
        }
      }}
  """
  @spec new(map() | String.t()) :: {:ok, SmartCity.Data.t()}
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

  def new(%{
        dataset_id: dataset_id,
        operational: operational,
        payload: payload,
        _metadata: metadata
      }) do
    timings = Map.get(operational, :timing, [])

    struct =
      struct(__MODULE__, %{
        dataset_id: dataset_id,
        payload: payload,
        _metadata: metadata,
        operational: %{operational | timing: Enum.map(timings, &Timing.new/1)}
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
  """
  @spec encode(SmartCity.Data.t()) ::
          {:ok, String.t()} | {:error, Jason.EncodeError.t() | Exception.t()}
  def encode(%__MODULE__{} = message) do
    Jason.encode(message)
  end

  @doc """
  Encodes `SmartCity.Data` into JSON. Typically used right before sending as a Kafka message.

  Raises an error if it fails to convert to a JSON string.
  """
  @spec encode!(SmartCity.Data.t()) :: String.t()
  def encode!(%__MODULE__{} = message) do
    Jason.encode!(message)
  end

  @doc """
  Adds a `SmartCity.Data.Timing` to the list of timings in this `SmartCity.Data`. The timing will be validated to ensure both start and end times have been set.

  Returns a `SmartCity.Data` struct with `new_timing` prepended to existing timings list.

  ## Parameters
    - message: A `SmartCity.Data`
    - new_timing: A timing you want to add. Must have `start_time` and `end_time` set
  """
  @spec add_timing(
          SmartCity.Data.t(),
          SmartCity.Data.Timing.t()
        ) :: SmartCity.Data.t()
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
  Creates a new `SmartCity.Data` struct using `new/1` and adds timing information to the message.

  Returns a `SmartCity.Data` struct with `new_timing` prepended to existing timings list.

  ## Parameters
    - message: A `SmartCity.Data`
    - app: The application that is asking to create the new `SmartCity.Data`. Ex. `reaper` or `voltron`
  """
  @spec timed_new(map(), String.t()) :: SmartCity.Data.t()
  def timed_new(msg, app) do
    label = inspect(&Data.new/1)

    case Timing.measure(app, label, fn -> new(msg) end) do
      {:ok, msg, timing} -> {:ok, msg |> add_timing(timing)}
      error -> error
    end
  end

  @doc """
  Transforms the `SmartCity.Data` `payload` field with the given unary function and replaces it in the message.

  Additionally, returns a `SmartCity.Data` struct with `new_timing` prepended to existing timings list.

  ## Parameters
    - message: A `SmartCity.Data`
    - app: The application that is asking to create the new `SmartCity.Data`. Ex. `reaper` or `voltron`
    - function: an arity 1 (/1) function that will transform the payload in the provided message
  """
  @spec timed_transform(
          SmartCity.Data.t(),
          String.t(),
          (payload() -> {:ok, term()} | {:error, term()})
        ) :: SmartCity.Data.t()
  def timed_transform(%Data{} = msg, app, function) when is_function(function, 1) do
    label = inspect(function)

    case Timing.measure(app, label, fn -> function.(msg.payload) end) do
      {:ok, result, timing} -> {:ok, msg |> add_timing(timing) |> Map.replace!(:payload, result)}
      error -> error
    end
  end

  @doc """
  Get all timings on this Data

  Returns a list of  `SmartCity.Data.Timing` structs or `[]`

  ## Parameters
    - data_message: The message to extract timings from
  """
  @spec get_all_timings(SmartCity.Data.t()) :: list(SmartCity.Data.Timing.t())
  def get_all_timings(%__MODULE__{operational: %{timing: timing}}), do: timing

  # Private functions
  defp put_in_operational(%__MODULE__{operational: operational} = message, key, value) do
    %{message | operational: Map.put(operational, key, value)}
  end
end
