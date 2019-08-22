defmodule SmartCity.Event.DatasetUpdate.Business do
  @moduledoc """
  A struct representing the business data portion of a dataset update struct definition (represented by `SmartCity.Event.DatasetUpdate`)

  You probably won't need to access this module directly; `SmartCity.Event.DatasetUpdate.new/1` will build this for you
  """

  alias SmartCity.Helpers

  @type not_required :: term() | nil
  @type license_or_default :: String.t()

  @type t :: %SmartCity.Event.DatasetUpdate.Business{
          authorEmail: not_required(),
          authorName: not_required(),
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
          spatial: not_required(),
          temporal: not_required()
        }

  @derive Jason.Encoder
  defstruct authorEmail: nil,
            authorName: nil,
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
            spatial: nil,
            temporal: nil

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
          contactEmail: _,
          contactName: _,
          dataTitle: _,
          description: _,
          modifiedDate: _,
          orgTitle: _
        } = msg
      ) do
    struct(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid business metadata: #{inspect(msg)}"
  end
end
