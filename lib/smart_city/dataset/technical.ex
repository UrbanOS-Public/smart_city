defmodule SmartCity.Dataset.Technical do
  @moduledoc """
  A struct defining technical metadata on a dataset.
  """
  alias SmartCity.Helpers

  @type not_required(type) :: type | nil

  @type t() :: %SmartCity.Dataset.Technical{
          # deprecated
          allow_duplicates: not_required(boolean()),
          # deprecated
          authHeaders: not_required(map()),
          # deprecated
          authBody: not_required(map()),
          # deprecated
          authUrl: String.t(),
          # deprecated
          authBodyEncodeMethod: not_required(String.t()),
          # deprecated
          cadence: not_required(String.t()),
          # deprecated
          credentials: boolean(),
          dataName: String.t(),
          orgId: not_required(String.t()),
          orgName: String.t(),
          private: not_required(boolean()),
          # deprecated
          protocol: not_required(list(String.t())),
          schema: not_required(list(map())),
          # deprecated
          sourceHeaders: not_required(map()),
          # deprecated
          sourceQueryParams: not_required(map()),
          # deprecated
          sourceUrl: String.t(),
          sourceType: not_required(String.t()),
          systemName: String.t(),
          topLevelSelector: not_required(String.t())
        }

  @derive Jason.Encoder
  defstruct allow_duplicates: true,
            authHeaders: %{},
            authBody: %{},
            authUrl: nil,
            authBodyEncodeMethod: nil,
            cadence: "never",
            credentials: false,
            dataName: nil,
            orgId: nil,
            orgName: nil,
            private: true,
            protocol: nil,
            schema: [],
            sourceHeaders: %{},
            sourceQueryParams: %{},
            sourceType: "remote",
            sourceUrl: nil,
            systemName: nil,
            topLevelSelector: nil

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
    msg |> create()
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
