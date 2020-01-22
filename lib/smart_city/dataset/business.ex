defmodule SmartCity.Dataset.Business do
  @moduledoc """
  A struct representing the business data portion of a dataset struct definition (represented by `SmartCity.Dataset`)

  You probably won't need to access this module directly; `SmartCity.Dataset.new/1` will build this for you
  """
  require Logger
  alias SmartCity.Helpers

  @type not_required :: term() | nil
  @type license_or_default :: String.t()

  @type t :: %SmartCity.Dataset.Business{
          authorEmail: not_required(),
          authorName: not_required(),
          benefitRating: not_required(),
          categories: not_required(),
          conformsToUri: not_required(),
          contactEmail: String.t(),
          contactName: String.t(),
          dataTitle: String.t(),
          describedByMimeType: not_required(),
          describedByUrl: not_required(),
          description: String.t(),
          homepage: not_required(),
          issuedDate: not_required(),
          keywords: not_required(),
          language: not_required(),
          license: license_or_default(),
          modifiedDate: String.t(),
          orgTitle: String.t(),
          parentDataset: not_required(),
          publishFrequency: not_required(),
          referenceUrls: not_required(),
          rights: not_required(),
          riskRating: not_required(),
          spatial: not_required(),
          temporal: not_required()
        }

  @derive Jason.Encoder
  defstruct authorEmail: nil,
            authorName: nil,
            benefitRating: nil,
            categories: nil,
            conformsToUri: nil,
            contactEmail: nil,
            contactName: nil,
            dataTitle: nil,
            describedByMimeType: nil,
            describedByUrl: nil,
            description: nil,
            homepage: nil,
            issuedDate: nil,
            keywords: nil,
            language: nil,
            license: nil,
            modifiedDate: nil,
            orgTitle: nil,
            parentDataset: nil,
            publishFrequency: nil,
            referenceUrls: nil,
            rights: nil,
            riskRating: nil,
            spatial: nil,
            temporal: nil

  use Accessible

  @doc """
  Returns a new `SmartCity.Dataset.Business` struct.
  Can be created from `Map` with string or atom keys.

  ## Parameters
    - msg: Map with string or atom keys that defines the dataset's business metadata. See `SmartCity.Dataset.Business` typespec for available keys.

    _Required Keys_
      - dataTitle
      - description
      - modifiedDate
      - orgTitle
      - contactName
      - contactEmail

    * License will default to [http://opendefinition.org/licenses/cc-by/](http://opendefinition.org/licenses/cc-by/) if not provided
  """
  def new(%{"dataTitle" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(
        %{
          contactEmail: _,
          contactName: _,
          dataTitle: _,
          description: _,
          orgTitle: _
        } = msg
      ) do
    fix_modified_date(msg)
    |> create()
  end

  def new(msg) do
    raise ArgumentError, "Invalid business metadata: #{inspect(msg)}"
  end

  defp fix_modified_date(business_map) do
    business_map
    |> Map.get_and_update(:modifiedDate, fn
      nil -> {nil, ""}
      current_value -> {current_value, current_value}
    end)
    |> elem(1)
  end

  defp create(%__MODULE__{} = struct), do: struct
  defp create(map), do: struct(%__MODULE__{}, map)
end
