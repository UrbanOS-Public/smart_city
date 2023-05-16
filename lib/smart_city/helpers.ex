defmodule SmartCity.Helpers do
  @moduledoc """
  Functions used across SmartCity modules.
  """

  @type file_type :: String.t()
  @type mime_type :: String.t()

  @doc """
  Convert a map with string keys to one with atom keys. Will convert keys nested in a sub-map or a
  map that is part of a list. Ignores existing atom keys.

  ## Examples

      iex> SmartCity.Helpers.to_atom_keys(%{"abc" => 123})
      %{abc: 123}

      iex> SmartCity.Helpers.to_atom_keys(%{"a" => %{"b" => "c"}})
      %{a: %{b: "c"}}

      iex> SmartCity.Helpers.to_atom_keys(%{"a" => [%{"b" => "c"}]})
      %{a: [%{b: "c"}]}
  """
  @spec to_atom_keys(map()) :: map()
  def to_atom_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, val} when is_map(val) or is_list(val) ->
        {safe_string_to_atom(key), to_atom_keys(val)}

      {key, val} when is_binary(key) ->
        {safe_string_to_atom(key), val}

      keyval ->
        keyval
    end)
  end

  def to_atom_keys(list) when is_list(list), do: Enum.map(list, &to_atom_keys/1)

  def to_atom_keys(value), do: value

  def safe_string_to_atom(string) when is_binary(string), do: String.to_atom(string)
  def safe_string_to_atom(atom) when is_atom(atom), do: atom
  def safe_string_to_atom(value), do: value

  @doc """
  Convert a map with atom keys to one with string keys. Will convert keys nested in a sub-map or a
  map that is part of a list. Ignores existing string keys.

  ## Examples

      iex> SmartCity.Helpers.to_string_keys(%{abc: 123})
      %{"abc" => 123}

      iex> SmartCity.Helpers.to_string_keys(%{a: %{b: "c"}})
      %{"a" => %{"b" => "c"}}

      iex> SmartCity.Helpers.to_string_keys(%{a: [%{b: "c"}]})
      %{"a" => [%{"b" => "c"}]}
  """
  @spec to_string_keys(map()) :: map()
  def to_string_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, val} when is_map(val) or is_list(val) ->
        {safe_atom_to_string(key), to_string_keys(val)}

      {key, val} when is_atom(key) ->
        {safe_atom_to_string(key), val}

      keyval ->
        keyval
    end)
  end

  def to_string_keys(list) when is_list(list), do: Enum.map(list, &to_string_keys/1)

  def to_string_keys(value), do: value

  def safe_atom_to_string(atom) when is_atom(atom), do: Atom.to_string(atom)
  def safe_atom_to_string(string) when is_binary(string), do: string
  def safe_atom_to_string(value), do: value

  @doc """
  Standardize file type definitions by deferring to the
  official media type of the file based on a supplied extension.
  """
  @spec mime_type(file_type()) :: mime_type()
  def mime_type(file_type) do
    downcased_type = String.downcase(file_type)

    case Plug.MIME.valid?(downcased_type) do
      true -> downcased_type
      false -> Plug.MIME.type(downcased_type)
    end
  end

  @doc """
  Merges two maps into one, including sub maps. Matching keys from the right map will override their corresponding key in the left map.
  """
  @spec deep_merge(map(), map()) :: map()
  def deep_merge(%{} = _left, %{} = right) when right == %{}, do: right
  def deep_merge(left, right), do: Map.merge(left, right, &deep_resolve/3)

  defp deep_resolve(_key, %{} = left, %{} = right), do: deep_merge(left, right)
  defp deep_resolve(_key, _left, right), do: right
end
