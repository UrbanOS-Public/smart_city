defmodule SmartCity.Events.FileUploaded do
  @moduledoc """
  Defines the information needed to process uploaded
  files by components of the system including the files'
  type, parent identifier, and location info.
  """

  @type t :: %SmartCity.Events.FileUploaded{
          :dataset_id => String.t(),
          :mime_type => String.t(),
          :bucket => String.t(),
          :key => String.t()
        }

  @derive Jason.Encoder
  defstruct [:dataset_id, :mime_type, :bucket, :key]
end
