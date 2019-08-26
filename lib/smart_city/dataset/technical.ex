defmodule SmartCity.Dataset.Technical do
  @moduledoc """
  A struct defining technical metadata on a dataset.
  """
  alias SmartCity.Helpers

  @type not_required(type) :: type | nil

  @type t() :: %SmartCity.Dataset.Technical{
          allow_duplicates: not_required(boolean()),
          authHeaders: not_required(map()),
          authUrl: String.t(),
          cadence: not_required(String.t()),
          dataName: String.t(),
          orgId: not_required(String.t()),
          orgName: String.t(),
          partitioner: not_required(%{type: String.t(), query: String.t()}),
          private: not_required(boolean()),
          protocol: not_required(list(String.t())),
          schema: not_required(list(map())),
          sourceFormat: String.t(),
          sourceHeaders: not_required(map()),
          sourceQueryParams: not_required(map()),
          sourceType: not_required(String.t()),
          sourceUrl: String.t(),
          systemName: String.t(),
          transformations: not_required(list()),
          validations: not_required(list())
        }

  @derive Jason.Encoder
  defstruct allow_duplicates: true,
            authHeaders: %{},
            authUrl: nil,
            cadence: "never",
            credentials: false,
            dataName: nil,
            orgId: nil,
            orgName: nil,
            partitioner: %{query: nil, type: nil},
            private: true,
            protocol: nil,
            schema: [],
            sourceFormat: nil,
            sourceHeaders: %{},
            sourceQueryParams: %{},
            sourceType: "remote",
            sourceUrl: nil,
            systemName: nil,
            transformations: [],
            validations: []

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
      - sourceFormat

    - sourceType will default to "remote"
    - cadence will default to "never"
  """
  @spec new(map()) :: SmartCity.Dataset.Technical.t()
  def new(%{"dataName" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataName: _, orgName: _, systemName: _, sourceUrl: _, sourceFormat: _} = msg) do
    struct(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end
end
