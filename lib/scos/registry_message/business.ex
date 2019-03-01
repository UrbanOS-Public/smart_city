defmodule SCOS.RegistryMessage.Business do
  @moduledoc """
  Struct defining business metadata on a registry event message.
  """

  defstruct dataTitle: nil,
            description: nil,
            modifiedDate: nil,
            orgTitle: nil,
            contactName: nil,
            contactEmail: nil,
            license: nil,
            keywords: [],
            rights: ""

  def new(%{"dataTitle" => _} = msg) do
    msg
    |> Map.new(fn {key, val} -> {String.to_atom(key), val} end)
    |> new()
  end

  def new(%{dataTitle: _, description: _, modifiedDate: _, orgTitle: _, contactName: _, contactEmail: _, license: _} = msg) do
    struct!(%__MODULE__{}, msg)
  end

  def new(msg) do
    raise ArgumentError, "Invalid business metadata: #{inspect(msg)}"
  end
end
