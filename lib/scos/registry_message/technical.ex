defmodule SCOS.RegistryMessage.Technical do
  @moduledoc """
  Struct defining technical metadata on a registry event message.
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
    |> atom_keys()
    |> new()
  end

  def new(%{dataName: dn, orgName: og, systemName: sn, stream: stream, sourceUrl: url} = msg) do
    tech_struct = %__MODULE__{dataName: dn, orgName: og, systemName: sn, stream: stream, sourceUrl: url}
    struct!(tech_struct, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end

  defp atom_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, val} when is_map(val) ->
        {String.to_atom(key), atom_keys(val)}
      {key, val} when is_list(val) ->
        {String.to_atom(key), Enum.map(val, &atom_keys/1)}
      {key, val} ->
        {String.to_atom(key), val}
    end)
  end

  defp atom_keys(value), do: value

end
