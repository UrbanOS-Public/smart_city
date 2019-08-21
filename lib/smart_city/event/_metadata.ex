defmodule SmartCity.Event.DatasetUpdate.Metadata do
  @moduledoc """
  A struct defining internal metadata on a dataset update event message.
  """

  alias SmartCity.Helpers

  @type t :: %SmartCity.Event.DatasetUpdate.Metadata{
          intendedUse: list(),
          expectedBenefit: list()
        }

  @derive Jason.Encoder
  defstruct intendedUse: [],
            expectedBenefit: []

  @doc """
  Returns a new `SmartCity.Event.DatasetUpdate.Metadata` struct.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input.

  ## Parameters

    - msg: Map with string or atom keys that defines the dataset's metadata.

  ## Examples

      iex> SmartCity.Event.DatasetUpdate.Metadata.new(%{"intendedUse" => ["a","b","c"], "expectedBenefit" => [1,2,3]})
      %SmartCity.Event.DatasetUpdate.Metadata{
        expectedBenefit: [1, 2, 3],
        intendedUse: ["a", "b", "c"]
      }

      iex> SmartCity.Event.DatasetUpdate.Metadata.new(%{:intendedUse => ["a","b","c"], :expectedBenefit => [1,2,3]})
      %SmartCity.Event.DatasetUpdate.Metadata{
        expectedBenefit: [1, 2, 3],
        intendedUse: ["a", "b", "c"]
      }

      iex> SmartCity.Event.DatasetUpdate.Metadata.new("Not a map")
      ** (ArgumentError) Invalid internal metadata: "Not a map"
  """
  @spec new(map()) :: SmartCity.Event.DatasetUpdate.Metadata.t()
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
