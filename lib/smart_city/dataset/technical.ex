defmodule SmartCity.Dataset.Technical do
  @moduledoc """
  A struct defining technical metadata on a dataset.
  """
  alias SmartCity.Helpers

  @type not_required(type) :: type | nil

  @type t() :: %SmartCity.Dataset.Technical{
          dataName: String.t(),
          orgId: not_required(String.t()),
          orgName: String.t(),
          private: not_required(boolean()),
          protocol: not_required(list(String.t())), # deprecated
          schema: not_required(list(map())),
          sourceHeaders: not_required(map()), # deprecated
          sourceQueryParams: not_required(map()), # deprecated
          sourceUrl: String.t(), # deprecated
          sourceType: not_required(String.t()),
          systemName: String.t()
        }

  @derive Jason.Encoder
  defstruct dataName: nil,
            orgId: nil,
            orgName: nil,
            private: true,
            protocol: nil,
            schema: [],
            sourceHeaders: %{},
            sourceQueryParams: %{},
            sourceType: "remote",
            sourceUrl: nil,
            systemName: nil

  use Accessible

  @doc """
  Returns a new `SmartCity.Dataset.Technical`.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input

  ## Parameters

    - msg: Map with string or atom keys that defines the dataset's technical metadata

    _Required Keys_
      - dataName
      - orgName
      - systemName
      - sourceUrl

    - sourceType will default to "remote"
  """
  @spec new(map()) :: SmartCity.Dataset.Technical.t()
  def new(%{"dataName" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataName: _, orgName: _, systemName: _, sourceUrl: _, schema: schema} = msg) do
    msg
    |> Map.put(:schema, Helpers.to_atom_keys(schema))
    |> create()
  end

  def new(%{dataName: _, orgName: _, systemName: _, sourceUrl: _} = msg) do
    create(msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
