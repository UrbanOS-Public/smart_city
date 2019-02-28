defmodule SCOS.DataMessage.Timing do
  @enforce_keys [:app, :label]
  defstruct app: nil, label: nil, start_time: nil, end_time: nil

  @validate_keys [:app, :label, :start_time, :end_time]

  def new(app, label, start_time, end_time) do
    new(app: app, label: label, start_time: start_time, end_time: end_time)
  end

  def new(opts) do
    struct!(__MODULE__, opts)
  end

  def current_time do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  def validate(%__MODULE__{} = timing) do
    case check_keys(timing, @validate_keys) do
      [] -> {:ok, timing}
      errors -> {:error, join_error_message(errors)}
    end
  end

  def validate!(%__MODULE__{} = timing) do
    case validate(timing) do
      {:ok, timing} -> timing
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  defp check_keys(timing, keys) do
    keys
    |> Enum.map(fn key ->
      case Map.get(timing, key, :missing_key) do
        :missing_key -> {:missing_key, key}
        nil -> {:invalid, key}
        _ -> []
      end
    end)
    |> List.flatten()
  end

  defp join_error_message(errors) do
    errors
    |> Enum.map(fn {reason, key} -> "#{Atom.to_string(key)}(#{Atom.to_string(reason)})" end)
    |> Enum.join(", ")
    |> (&"Errors with: #{&1}").()
  end
end
