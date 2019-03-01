defmodule SCOS.RegistryMessage.Helpers do
  @moduledoc """
  Functions used across `SCOS.RegistryMessage` modules.
  """

  def to_atom_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, val} when is_map(val) ->
        {String.to_atom(key), to_atom_keys(val)}

      {key, val} when is_list(val) ->
        {String.to_atom(key), Enum.map(val, &to_atom_keys/1)}

      {key, val} when is_binary(key) ->
        {String.to_atom(key), val}

      keyval ->
        keyval
    end)
  end

  def to_atom_keys(value), do: value
end
