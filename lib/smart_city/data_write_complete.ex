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

  defp create(%{id: _, timestamp: _} = msg) do
    data_write_complete = struct(%__MODULE__{}, msg)

    {:ok, data_write_complete}
  end

  defp create(msg) do
    {:error, "Invalid data:write:complete #{inspect(msg)}"}
  end
end
