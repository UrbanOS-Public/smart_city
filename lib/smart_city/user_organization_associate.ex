defmodule SmartCity.UserOrganizationAssociate do
  @moduledoc """
  Defines a user organization association.
  """
  alias SmartCity.BaseStruct

  @type subject_id :: String.t()
  @type org_id :: SmartCity.Organization.id()
  @type t :: %SmartCity.UserOrganizationAssociate{
          :subject_id => subject_id(),
          :org_id => org_id()
        }

  @derive Jason.Encoder
  defstruct subject_id: nil,
            org_id: nil

  @doc """
  Instantiates an instance of a user organization associate event struct.
  """
  @spec new(String.t() | map()) :: {:ok, map()} | {:error, String.t()}
  def new(msg) do
    BaseStruct.new(msg)
    |> create()
  end

  defp create(%{subject_id: _, org_id: _} = msg) do
    user_organization_associate = struct(%__MODULE__{}, msg)

    {:ok, user_organization_associate}
  end

  defp create(msg) do
    {:error, "Invalid user:organization:associate: #{inspect(msg)}"}
  end
end
