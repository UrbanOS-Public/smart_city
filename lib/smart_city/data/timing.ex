defmodule SmartCity.Data.Timing do
  @moduledoc """
  Timing struct for adding timing metrics to `SmartCity.Data` messages
  """
  @enforce_keys [:app, :label]
  @derive Jason.Encoder
  defstruct app: nil, label: nil, start_time: nil, end_time: nil

  @validate_keys [:app, :label, :start_time, :end_time]

  @doc """
  Creates a new `SmartCity.Data.Timing` struct, passing in all fields.

  Returns a `SmartCity.Data.Timing` struct or raises `ArgumentError`.

  ## Parameters

    - app: application for which timing metrics are being measured
    - label: description of timing measurement
    - start_time: time when measurement has begun
    - end_time: time when measurement has finished

  ## Examples

      iex> SmartCity.Data.Timing.new("foo", "bar", "not_validated", "not_validated")
      %SmartCity.Data.Timing{
        app: "foo",
        label: "bar",
        start_time: "not_validated",
        end_time: "not_validated"
      }
  """
  @spec new(term(), term(), term(), term()) :: %SmartCity.Data.Timing{}
  def new(app, label, start_time, end_time) do
    new(app: app, label: label, start_time: start_time, end_time: end_time)
  end

  @doc """
  Creates a new `SmartCity.Data.Timing` from opts.

  Returns a `SmartCity.Data.Timing` struct or raises `ArgumentError`

  ## Parameters

    - opts: Keyword list or map containing struct attributes
          Required keys: #{@enforce_keys |> Enum.map(&"`#{Atom.to_string(&1)}`") |> Enum.join(", ")}
          See `Kernel.struct!/2`.
  """
  @spec new(
          %{:app => term(), :label => term(), optional(:start_time) => term(), optional(:end_time) => term()}
          | list()
        ) :: %SmartCity.Data.Timing{}
  def new(opts) do
    struct!(__MODULE__, opts)
  end

  @doc """
  Gets the current time. This function should always be used for generating times to be used in timings to ensure consistency across all services.

  Returns current UTC Time in ISO8601 format
  """
  @spec current_time() :: String.t()
  def current_time do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  @doc """
  Validate that all required keys are present and valid (not nil).

  Set by `@validate_keys` module attribute.
  Currently checks: #{@enforce_keys |> Enum.map(&"`#{Atom.to_string(&1)}`") |> Enum.join(", ")}

  Returns `{:ok, timing}` on success or `{:error, reason}` on failure

  ## Parameters

    - timing: The `SmartCity.Data.Timing` struct to validate
  """
  @spec validate(%SmartCity.Data.Timing{}) :: {:ok, %SmartCity.Data.Timing{}} | {:error, String.t()}
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
  @spec validate!(%SmartCity.Data.Timing{}) :: {:ok, %SmartCity.Data.Timing{}}
  def validate!(%__MODULE__{} = timing) do
    case validate(timing) do
      {:ok, timing} -> timing
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  @doc """
  Wraps the results of a function call with measured timing information

  Returns {:ok, `result`, `timing`} on success, or {:error, `reason`} on failure
  """
  @spec measure(String.t(), String.t(), function()) :: {:ok, term(), %SmartCity.Data.Timing{}} | {:error, String.t()}
  def measure(app, label, function) when is_function(function) do
    start_time = DateTime.utc_now()

    with {:ok, result} <- function.() do
      end_time = DateTime.utc_now()

      {:ok, result, new(%{app: app, label: label, start_time: start_time, end_time: end_time})}
    else
      {:error, reason} -> {:error, reason}
      reason -> {:error, reason}
    end
  end

  defp check_keys(timing, keys) do
    keys
    |> Enum.map(&check_key(timing, &1))
    |> List.flatten()
  end

  defp check_key(timing, key) do
    case Map.get(timing, key, :missing_key) do
      :missing_key -> {:missing_key, key}
      nil -> {:invalid, key}
      _ -> []
    end
  end

  defp join_error_message(errors) do
    error_msg =
      errors
      |> Enum.map(fn {reason, key} -> "#{Atom.to_string(key)}(#{Atom.to_string(reason)})" end)
      |> Enum.join(", ")

    "Errors with: #{error_msg}"
  end
end
