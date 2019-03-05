defmodule SCOS.RegistryMessage.Technical do
  @moduledoc """
  Struct defining technical metadata on a registry event message.
  """
  alias SCOS.RegistryMessage.Helpers

  @derive Jason.Encoder
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
            headers: %{},
            sourceFormat: nil

  @doc """
  Returns a new `SCOS.RegistryMessage.Technical`.
  Can be created from `Map` with string or atom keys.
  """
  def new(%{"dataName" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataName: _, orgName: _, systemName: _, stream: _, sourceUrl: _, sourceFormat: _} = msg) do
    struct(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end
end
