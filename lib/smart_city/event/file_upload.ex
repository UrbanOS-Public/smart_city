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
          :dataset_id => id(),
          :mime_type => mime_type(),
          :bucket => bucket(),
          :key => key()
        }

  @derive Jason.Encoder
  defstruct version: "0.1", dataset_id: nil, mime_type: nil, bucket: nil, key: nil

  @doc """
  Instantiates an instance of a file upload event struct.
  """
  @spec new(String.t() | map()) :: {:ok, SmartCity.Event.FileUpload.t()} | {:error, term()}
  def new(encoded_event) when is_binary(encoded_event) do
    with {:ok, decoded_event} <- Jason.decode(encoded_event, keys: :atoms) do
      new(decoded_event)
    end
  end

  def new(%{"dataset_id" => _} = event) do
    event
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataset_id: id, mime_type: type, bucket: bucket, key: key}) do
    event =
      struct(%__MODULE__{}, %{
        dataset_id: id,
        mime_type: type,
        bucket: bucket,
        key: key
      })

    {:ok, event}
  rescue
    error -> {:error, error}
  end

  def new(bad_event) do
    {:error, "Invalid file upload event: #{inspect(bad_event)}"}
  end

  @doc """
  Standardize file type definitions by deferring to the
  official media type of the file based on a supplied extension.
  """
  @spec type(extension()) :: mime_type()
  def type(extension), do: MIME.type(extension)
end
