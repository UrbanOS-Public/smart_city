defmodule SmartCity.HostedFile do
  @moduledoc """
  Defines the information needed to process uploaded
  files by components of the system including the files'
  type, parent identifier, and location info.
  """
  @type id :: String.t()
  @type bucket :: String.t()
  @type key :: String.t()
  @type t :: %SmartCity.HostedFile{
          :bucket => bucket(),
          :dataset_id => id(),
          :key => key(),
          :mime_type => SmartCity.Helpers.mime_type()
        }

  @derive Jason.Encoder
  defstruct bucket: nil,
            dataset_id: nil,
            key: nil,
            mime_type: nil,
            version: "0.1"

  alias SmartCity.BaseStruct

  @doc """
  Instantiates an instance of a file upload event struct.
  """

  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) do
    msg
    |> BaseStruct.new()
    |> create()
  end

  defp create(%{dataset_id: id, mime_type: type, bucket: bucket, key: key}) do
    mime_type = SmartCity.Helpers.mime_type(type)

    file =
      struct(%__MODULE__{}, %{
        bucket: bucket,
        dataset_id: id,
        key: key,
        mime_type: mime_type
      })

    {:ok, file}
  end

  defp create(bad_struct) do
    {:error, "Invalid file upload event: #{inspect(bad_struct)}"}
  end
end
