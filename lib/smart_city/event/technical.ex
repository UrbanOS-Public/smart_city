defmodule SmartCity.Event.DatasetUpdate.Technical do
  @moduledoc """
  A struct defining technical metadata on a registry event message.
  """
  alias SmartCity.Helpers

  @type not_required(type) :: type | nil

  @type t() :: %SmartCity.Event.DatasetUpdate.Technical{
          dataName: String.t(),
          orgName: String.t(),
          systemName: String.t(),
          sourceUrl: String.t(),
          authUrl: String.t(),
          sourceFormat: String.t(),
          schema: not_required(list(map())),
          orgId: not_required(String.t()),
          sourceType: not_required(String.t()),
          cadence: not_required(String.t()),
          sourceQueryParams: not_required(map()),
          transformations: not_required(list()),
          validations: not_required(list()),
          sourceHeaders: not_required(map()),
          authHeaders: not_required(map()),
          protocol: not_required(list(String.t())),
          partitioner: not_required(%{type: String.t(), query: String.t()}),
          private: not_required(boolean()),
          allow_duplicates: not_required(boolean())
        }

  @derive Jason.Encoder
  defstruct allow_duplicates: true,
            cadence: "never",
            credentials: false,
            dataName: nil,
            sourceHeaders: %{},
            authHeaders: %{},
            orgId: nil,
            orgName: nil,
            partitioner: %{type: nil, query: nil},
            private: true,
            sourceQueryParams: %{},
            schema: [],
            sourceFormat: nil,
            sourceType: "remote",
            sourceUrl: nil,
            authUrl: nil,
            systemName: nil,
            protocol: nil,
            transformations: [],
            validations: []

  @doc """
  Returns a new `SmartCity.Event.DatasetUpdate.Technical`.
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
  @spec new(map()) :: SmartCity.Event.DatasetUpdate.Technical.t()
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
