defmodule SmartCity.OrganizationUserAssociate do
  @moduledoc """
  Defines a user organization association.
  """
  alias SmartCity.BaseStruct

  @type user_id :: String.t()
  @type org_id :: SmartCity.Organization.id()
  @type t :: %SmartCity.OrganizationUserAssociate{
          :user_id => user_id(),
          :org_id => org_id()
        }

  @derive Jason.Encoder
  defstruct user_id: nil,
            org_id: nil

  @doc """
  Instantiates an instance of a organization user associate event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{user_id: _, org_id: _} = msg) do
    organization_user_associate = struct(%__MODULE__{}, msg)

    {:ok, organization_user_associate}
  end

  defp create(msg) do
    {:error, "Invalid organization:user:associate: #{inspect(msg)}"}
  end
end
