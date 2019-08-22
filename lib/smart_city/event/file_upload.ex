defmodule SmartCity.Event.FileUpload do
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
  @type t :: %SmartCity.Event.FileUpload{
          :bucket => bucket(),
          :dataset_id => id(),
          :key => key(),
          :mime_type => mime_type()
        }

  @derive Jason.Encoder
  defstruct bucket: nil,
            dataset_id: nil,
            key: nil,
            mime_type: nil,
            version: "0.1"

  alias SmartCity.Event.BaseEvent

  @doc """
  Instantiates an instance of a file upload event struct.
  """

  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) do
    msg
    |> BaseEvent.new()
    |> create()
  end

  defp create(%{dataset_id: id, mime_type: type, bucket: bucket, key: key}) do
    event =
      struct(%__MODULE__{}, %{
        bucket: bucket,
        dataset_id: id,
        key: key,
        mime_type: type
      })

    {:ok, event}
  rescue
    error -> {:error, error}
  end

  defp create(bad_event) do
    {:error, "Invalid file upload event: #{inspect(bad_event)}"}
  end

  @doc """
  Standardize file type definitions by deferring to the
  official media type of the file based on a supplied extension.
  """
  @spec type(extension()) :: mime_type()
  def type(extension), do: MIME.type(extension)
end
