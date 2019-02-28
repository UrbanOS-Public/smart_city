defmodule SCOS.DataMessage.Timing do
  @moduledoc """
  Timing struct for adding timing metrics to DataMessages
  """
  @enforce_keys [:app, :label]
  defstruct app: nil, label: nil, start_time: nil, end_time: nil

  @validate_keys [:app, :label, :start_time, :end_time]

  @doc """
  Creates a new `SCOS.DataMessage.Timing` struct, passing in all fields.

  Returns a `%SCOS.DataMessage.Timing{}` struct or raises `ArgumentError`.

  See `new/1`.
  """
  def new(app, label, start_time, end_time) do
    new(app: app, label: label, start_time: start_time, end_time: end_time)
  end

  @doc """
  Creates a new `SCOS.DataMessage.Timing` from opts.

  Returns a `%SCOS.DataMessage.Timing{}` struct or raises `ArgumentError`

  ## Parameters
  - opts: Keyword list or map containing struct attributes
          Required keys: #{@enforce_keys |> Enum.map(&"`#{Atom.to_string(&1)}`") |> Enum.join(", ")}
          See `Kernel.struct!/2`.
  """
  def new(opts) do
    struct!(__MODULE__, opts)
  end

  @doc """
  Gets the current time. This function should always be used for generating times to be used in timings to ensure consistency across all services.

  Returns current UTC Time in ISO8601 format
  """
  def current_time do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  @doc """
  Validate that all required keys are present and valid (not nil).

  Set by `@validate_keys` module attribute.
  Currently checks: #{@enforce_keys |> Enum.map(&"`#{Atom.to_string(&1)}`") |> Enum.join(", ")}

  Returns `{:ok, timing}` on success or `{:error, reason}` on failure

  ## Parameters
  - timing: The `SCOS.DataMessage.Timing` struct to validate
  """
  def validate(%__MODULE__{} = timing) do
    case check_keys(timing, @validate_keys) do
      [] -> {:ok, timing}
      errors -> {:error, join_error_message(errors)}
    end
  end

  @doc """
  Validate that all required keys are present and valid (not nil).

  Returns `timing` on success, or raises `ArgumentError` on failure
  See `validate/1`
  """
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
