defmodule SmartCity.DataWriteComplete do
  @moduledoc """
  Defines a data persisted event.
  """
  alias SmartCity.BaseStruct

  @type id :: String.t()
  @type timestamp :: DateTime.t()
  @type t :: %SmartCity.DataWriteComplete{
          :id => id(),
          :timestamp => timestamp()
        }

  @derive Jason.Encoder
  defstruct id: nil,
            timestamp: nil

  @doc """
  Instantiates an instance of a data write complete event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{id: _, timestamp: timestamp} = msg) when is_binary(timestamp) do
    {:ok, struct(%__MODULE__{}, msg)}
  end

  defp create(%{id: _, timestamp: %DateTime{}} = msg) do
    {:ok, struct(%__MODULE__{}, Map.update!(msg, :timestamp, &DateTime.to_iso8601/1))}
  end

  defp create(msg) do
    {:error, "Invalid data:write:complete #{inspect(msg)}"}
  end
end
