defmodule SCOS.DataMessage do
  @moduledoc """
  Message struct shared amongst all SCOS microservices.
  """

  defstruct _metadata_: %{org: nil, name: nil, stream: false}, dataset_id: nil, payload: nil, operational: %{timing: []}

  def parse_message(value) when is_binary(value) do
    value
    |> Jason.decode!(keys: :atoms)
    |> make_struct()
  end

  def encode_message(%__MODULE__{} = message) do
    message
    |> Map.from_struct()
    |> Jason.encode!()
  end

  def add_timing(%__MODULE__{operational: %{timing: timing}} = message, app, label, start_time, end_time) do
    new_timing = make_timing(app, label, start_time, end_time)

    put_in_operational(message, timing, [new_timing | timing])
  end

  def get_all_timings(%__MODULE__{operational: %{timing: timing}}), do: timing

  # Private functions
  defp put_in_operational(%__MODULE__{} = message, key, value) do
    put_in(message, [:operational, key], value)
  end

  defp make_struct(value_map) do
    struct!(__MODULE__, value_map)
  end

  defp make_timing(app, label, start_time, end_time) do
    %{
      app: app,
      label: label,
      start_time: start_time,
      end_time: end_time
    }
  end
end
