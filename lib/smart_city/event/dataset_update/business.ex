defmodule SmartCity.Event.DatasetUpdate.Business do
  @moduledoc """
  A struct representing the business data portion of a dataset update struct definition (represented by `SmartCity.Event.DatasetUpdate`)

  You probably won't need to access this module directly; `SmartCity.Event.DatasetUpdate.new/1` will build this for you
  """

  alias SmartCity.Helpers

  @type not_required :: term() | nil
  @type license_or_default :: String.t()

  @type t :: %SmartCity.Event.DatasetUpdate.Business{
          dataTitle: String.t(),
          description: String.t(),
          modifiedDate: String.t(),
          orgTitle: String.t(),
          contactName: String.t(),
          contactEmail: String.t(),
          authorName: not_required(),
          authorEmail: not_required(),
          categories: not_required(),
          conformsToUri: not_required(),
          describedByMimeType: not_required(),
          describedByUrl: not_required(),
          homepage: not_required(),
          issuedDate: not_required(),
          keywords: not_required(),
          language: not_required(),
          license: license_or_default(),
          parentDataset: not_required(),
          publishFrequency: not_required(),
          referenceUrls: not_required(),
          rights: not_required(),
          spatial: not_required(),
          temporal: not_required()
        }

  @derive Jason.Encoder
  defstruct dataTitle: nil,
            description: nil,
            modifiedDate: nil,
            orgTitle: nil,
            contactName: nil,
            contactEmail: nil,
            authorName: nil,
            authorEmail: nil,
            license: nil,
            keywords: nil,
            rights: nil,
            homepage: nil,
            spatial: nil,
            temporal: nil,
            publishFrequency: nil,
            conformsToUri: nil,
            describedByUrl: nil,
            describedByMimeType: nil,
            parentDataset: nil,
            issuedDate: nil,
            language: nil,
            referenceUrls: nil,
            categories: nil

  @doc """
  Returns a new `SmartCity.Event.DatasetUpdate.Business` struct.
  Can be created from `Map` with string or atom keys.

  ## Parameters
    - msg: Map with string or atom keys that defines the dataset's business metadata. See `SmartCity.Event.DatasetUpdate.Business` typespec for available keys.

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
          dataTitle: _,
          description: _,
          modifiedDate: _,
          orgTitle: _,
          contactName: _,
          contactEmail: _
        } = msg
      ) do
    struct(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid business metadata: #{inspect(msg)}"
  end
end
