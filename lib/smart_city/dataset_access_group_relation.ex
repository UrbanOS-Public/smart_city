defmodule SmartCity.DatasetAccessGroupRelation do
  @moduledoc """
  Defines a dataset access group association.
  """
  alias SmartCity.BaseStruct

  @type dataset_id :: SmartCity.Dataset.id()
  @type access_group_id :: SmartCity.AccessGroup.id()
  @type t :: %SmartCity.DatasetAccessGroupRelation{
          :dataset_id => dataset_id(),
          :access_group_id => access_group_id()
        }

  @derive Jason.Encoder
  defstruct dataset_id: nil,
            access_group_id: nil

  @doc """
  Instantiates an instance of a dataset access group relation event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{dataset_id: _, access_group_id: _} = msg) do
    dataset_access_group_relation = struct(%__MODULE__{}, msg)

    {:ok, dataset_access_group_relation}
  end

  defp create(msg) do
    {:error, "Invalid dataset:access_group:relation: #{inspect(msg)}"}
  end
end
