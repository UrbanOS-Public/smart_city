defmodule SCOS.RegistryMessage do
  @moduledoc """
  Struct defining a registry event message.
  """
  alias SCOS.RegistryMessage.Technical

  defstruct [:id, :business, :technical]

  def new(%{"id" => _id} = msg) do
    msg
    |> Map.new(fn {key, val} -> {String.to_atom(key), val} end)
    |> new()
  end

  def new(%{id: id, business: biz, technical: tech}) do
    struct!(%__MODULE__{}, %{id: id, business: biz, technical: Technical.new(tech)})
  end

  def new(msg), do: raise ArgumentError, "Invalid registry message: #{inspect(msg)}"
end
