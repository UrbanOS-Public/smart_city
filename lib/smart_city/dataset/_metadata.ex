defmodule SmartCity.Dataset.Metadata do
  @moduledoc """
  A struct defining internal metadata on a dataset.
  """

  alias SmartCity.Helpers

  @type t :: %SmartCity.Dataset.Metadata{
          expectedBenefit: list(),
          intendedUse: list()
        }

  @derive Jason.Encoder
  defstruct expectedBenefit: [],
            intendedUse: []

  @doc """
  Returns a new `SmartCity.Dataset.Metadata` struct.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input.

  ## Parameters

    - msg: Map with string or atom keys that defines the dataset's metadata.

  ## Examples

      iex> SmartCity.Dataset.Metadata.new(%{"intendedUse" => ["a","b","c"], "expectedBenefit" => [1,2,3]})
      %SmartCity.Dataset.Metadata{
        expectedBenefit: [1, 2, 3],
        intendedUse: ["a", "b", "c"]
      }

      iex> SmartCity.Dataset.Metadata.new(%{:intendedUse => ["a","b","c"], :expectedBenefit => [1,2,3]})
      %SmartCity.Dataset.Metadata{
        expectedBenefit: [1, 2, 3],
        intendedUse: ["a", "b", "c"]
      }

      iex> SmartCity.Dataset.Metadata.new("Not a map")
      ** (ArgumentError) Invalid internal metadata: "Not a map"
  """
  @spec new(map()) :: SmartCity.Dataset.Metadata.t()
  def new(%{} = msg) do
    msg_atoms =
      case is_binary(List.first(Map.keys(msg))) do
        true ->
          Helpers.to_atom_keys(msg)

        false ->
          msg
      end

    struct(%__MODULE__{}, msg_atoms)
  end

  def new(msg) do
    raise ArgumentError, "Invalid internal metadata: #{inspect(msg)}"
  end
end
