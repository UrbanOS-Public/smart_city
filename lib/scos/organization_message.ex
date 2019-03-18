defmodule SCOS.OrganizationMessage do
  @moduledoc """
  Struct defining an organization event message.
  """
  alias SCOS.Helpers

  @derive Jason.Encoder
  defstruct [:id, :orgTitle, :orgName, :description, :logoUrl, :homepage]

  @doc """
  Returns a new `SCOS.OrganizationMessage` struct.

  Can be created from:
  - map with string keys
  - map with atom keys
  - JSON
  """
  def new(msg) when is_binary(msg) do
    with {:ok, decoded} <- Jason.decode(msg, keys: :atoms) do
      new(decoded)
    end
  end

  def new(%{"id" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{id: _, orgName: _, orgTitle: _} = msg) do
    struct = struct(%__MODULE__{}, msg)

    {:ok, struct}
  end

  def new(msg) do
    {:error, "Invalid organization message: #{inspect(msg)}"}
  end
end
