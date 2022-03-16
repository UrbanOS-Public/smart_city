defmodule SmartCity.UserAccessGroupRelation do
  @moduledoc """
  Defines a user access group relation.
  """
  alias SmartCity.BaseStruct

  @type subject_id :: String.t()
  @type access_group_id :: SmartCity.AccessGroup.id()
  @type t :: %SmartCity.UserAccessGroupRelation{
          :subject_id => subject_id(),
          :access_group_id => access_group_id()
        }

  @derive Jason.Encoder
  defstruct subject_id: nil,
            access_group_id: nil

  @doc """
  Instantiates an instance of a user access group relation event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{subject_id: _, access_group_id: _} = msg) do
    user_access_group_relation = struct(%__MODULE__{}, msg)

    {:ok, user_access_group_relation}
  end

  defp create(msg) do
    {:error, "Invalid user:access_group:relation: #{inspect(msg)}"}
  end
end
