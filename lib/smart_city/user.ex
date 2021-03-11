defmodule SmartCity.User do
  @moduledoc """
  Defines a user organization association.
  """
  alias SmartCity.BaseStruct

  @type subject_id :: String.t()
  @type email :: String.t()
  @type t :: %SmartCity.User{
          :subject_id => String.t(),
          :email => String.t()
        }

  @derive Jason.Encoder
  defstruct subject_id: nil,
            email: nil

  @doc """
  Instantiates an instance of a user organization associate event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{subject_id: _, email: _} = msg) do
    user = struct(%__MODULE__{}, msg)

    {:ok, user}
  end

  defp create(msg) do
    {:error, "Invalid user #{inspect(msg)}"}
  end
end
