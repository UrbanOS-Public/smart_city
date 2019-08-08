defmodule SmartCity.Events.FileUploaded do
  @moduledoc """
  Defines the information needed to process uploaded
  files by components of the system including the files'
  type, parent identifier, and location info.
  """

  @type extension :: String.t()
  @type mime_type :: String.t()
  @type id :: String.t()
  @type bucket :: String.t()
  @type key :: String.t()
  @type t :: %SmartCity.Events.FileUploaded{
          :dataset_id => id(),
          :mime_type => mime_type(),
          :bucket => bucket(),
          :key => key()
        }

  @derive Jason.Encoder
  defstruct [:dataset_id, :mime_type, :bucket, :key]

  @doc """
  Standardize file type definitions by deferring to the
  official media type of the file based on a supplied extension.
  """
  @spec type(extension()) :: mime_type()
  def type(extension), do: MIME.type(extension)
end
