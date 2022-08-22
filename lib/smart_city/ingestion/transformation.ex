defmodule SmartCity.Ingestion.Transformation do
  @moduledoc """
  A struct representing the transformations portion of an ingestion struct definition (represented by `SmartCity.Ingestion`)

  You probably won't need to access this module directly; `SmartCity.Ingestion.new/1` will build this for you
  """
  require Logger
  alias SmartCity.Helpers

  @type not_required :: term() | nil
  @type license_or_default :: String.t()

  @type t :: %SmartCity.Ingestion.Transformation{
          type: String.t(),
          parameters: map(),
          id: String.t(),
          sequence: Integer.t()
        }

  @derive Jason.Encoder
  defstruct type: nil,
            parameters: nil,
            id: nil,
            sequence: nil

  use Accessible

  @doc """
  Returns a new `SmartCity.Ingestion.Transformation` struct.
  Can be created from `Map` with string or atom keys.

  ## Parameters
    - type:
    - parameters:

    * License will default to [http://opendefinition.org/licenses/cc-by/](http://opendefinition.org/licenses/cc-by/) if not provided
  """
  def new(%{"type" => _, "parameters" => _, "id" => _, "sequence" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{type: _, parameters: _, id: _, sequence: _} = msg) do
    msg
    |> create()
  end

  def new(msg) do
    raise ArgumentError, "Invalid transformation: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
