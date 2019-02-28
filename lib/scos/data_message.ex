defmodule SCOS.DataMessage do
  @moduledoc """
  Message struct shared amongst all SCOS microservices.
  """

  alias SCOS.DataMessage
  alias SCOS.DataMessage.Timing

  @enforce_keys [:dataset_id, :payload, :_metadata, :operational]
  defstruct _metadata: %{org: nil, name: nil, stream: false}, dataset_id: nil, payload: nil, operational: %{timing: []}

  def new(opts) do
    struct!(__MODULE__, opts)
  end

  def parse_message(value) when is_binary(value) do
    value
    |> Jason.decode!(keys: :atoms)
    |> new()
  end

  def encode_message(%__MODULE__{} = message) do
    message
    |> Map.from_struct()
    |> Jason.encode!()
  end

  def add_timing(%__MODULE__{operational: %{timing: timing}} = message, %DataMessage.Timing{} = new_timing) do
    case Timing.validate(new_timing) do
      {:ok, new_timing} -> put_in_operational(message, :timing, [new_timing | timing])
      {:error, errors} -> raise ArgumentError, "Invalid Timing: #{errors}"
    end

    put_in_operational(message, :timing, [new_timing | timing])
  end

  def get_all_timings(%__MODULE__{operational: %{timing: timing}}), do: timing

  # Private functions
  defp put_in_operational(%__MODULE__{operational: operational} = message, key, value) do
    %{message | operational: Map.put(operational, key, value)}
  end
end
