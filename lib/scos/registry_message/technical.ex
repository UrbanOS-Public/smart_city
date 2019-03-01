defmodule SCOS.RegistryMessage.Technical do
  @moduledoc """
  Struct defining technical metadata on a registry event message.
  """
  alias SCOS.RegistryMessage.Helpers

  defstruct dataName: nil,
            orgName: nil,
            systemName: nil,
            stream: nil,
            schema: [],
            sourceUrl: nil,
            cadence: nil,
            queryParams: %{},
            transformations: [],
            validations: [],
            headers: %{}

  def new(%{"dataName" => _dn} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataName: _, orgName: _, systemName: _, stream: _, sourceUrl: _} = msg) do
    struct!(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end
end
