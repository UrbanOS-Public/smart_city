defmodule SCOS.DataMessage do
  @moduledoc """
  Message struct shared amongst all SCOS microservices.
  """

  alias SCOS.DataMessage
  alias SCOS.DataMessage.Timing

  @derive Jason.Encoder
  @enforce_keys [:dataset_id, :payload, :_metadata, :operational]
  defstruct _metadata: %{org: nil, name: nil, stream: false},
            dataset_id: nil,
            payload: nil,
            operational: %{timing: []}

  @doc """
  Creates a new `SCOS.DataMessage` from opts.

  Returns a `%SCOS.DataMessage` struct

  ## Parameters
  - opts: Keyword list or map containing struct attributes
          Required keys: #{
    @enforce_keys |> Enum.map(&"`#{Atom.to_string(&1)}`") |> Enum.join(", ")
  }
          See `Kernel.struct!/2`.

  ## Examples

      iex> SCOS.DataMessage.new(dataset_id: "a_guid", payload: "the_data", _metadata: %{org: "scos", name: "example"}, operational: %{})
      %SCOS.DataMessage{
        dataset_id: "a_guid",
        payload: "the_data",
        _metadata: %{org: "scos", name: "example"},
        operational: %{}
      }
  """
  def new(opts) do
    struct!(__MODULE__, opts)
  end

  @doc """
  Parses a JSON value into a `SCOS.DataMessage`. Typically pulled from the value field of a Kafka message.

  Returns a `%SCOS.DataMessage{}` struct

  ## Parameters
  - value: A JSON string containing all required keys. See `new/1` for a listing of required keys
  """
  def parse_message(value) when is_binary(value) do
    value
    |> Jason.decode!(keys: :atoms)
    |> new()
  end

  @doc """
  Encodes `SCOS.DataMessage` into JSON. Typically used right before sending as a Kafka message.

  Returns a JSON string.

  ## Parameters
  - message: A `SCOS.DataMessage` that you want to encode
  """
  def encode(%__MODULE__{} = message) do
    Jason.encode(message)
  end

  @doc """
  Adds a `SCOS.DataMessage.Timing` to the list of timings in this DataMessage. The timing will be validated to ensure both start and end times have been set.

  Returns a `%SCOS.DataMessage` struct with `new_timing` prepended to timings already in the DataMessage.

  ## Parameters
  - message: A `SCOS.DataMessage`
  - new_timing: A timing you want to add. Must have `start_time` and `end_time` set
  """
  def add_timing(
        %__MODULE__{operational: %{timing: timing}} = message,
        %DataMessage.Timing{} = new_timing
      ) do
    case Timing.validate(new_timing) do
      {:ok, new_timing} -> put_in_operational(message, :timing, [new_timing | timing])
      {:error, errors} -> raise ArgumentError, "Invalid Timing: #{errors}"
    end
  end

  @doc """
  Get all timings on this DataMessage

  Returns a list of  `%SCOS.DataMessage.Timing{}` structs or `[]`

  ## Parameters
  - data_message: The message to extract timings from
  """
  def get_all_timings(%__MODULE__{operational: %{timing: timing}}), do: timing

  # Private functions
  defp put_in_operational(%__MODULE__{operational: operational} = message, key, value) do
    %{message | operational: Map.put(operational, key, value)}
  end
end
