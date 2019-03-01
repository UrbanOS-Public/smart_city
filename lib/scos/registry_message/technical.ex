defmodule SCOS.RegistryMessage.Technical do
  @moduledoc """
  Struct defining business metadata on a registry event message.
  """
  @enforce_keys [:dataName, :orgName, :systemName, :stream, :sourceUrl]
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
    |> Map.new(fn {key, val} -> {String.to_atom(key), val} end)
    |> new()
  end

  def new(%{dataName: dn, orgName: og, systemName: sn, stream: stream, sourceUrl: url} = msg) do
    tech_struct = %__MODULE__{dataName: dn, orgName: og, systemName: sn, stream: stream, sourceUrl: url}
    struct!(tech_struct, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end
end
