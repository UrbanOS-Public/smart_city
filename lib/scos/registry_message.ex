defmodule SCOS.RegistryMessage do
  @moduledoc """
  Struct defining a registry event message.
  """
  alias SCOS.RegistryMessage.Business
  alias SCOS.RegistryMessage.Technical
  alias SCOS.RegistryMessage.Helpers

  defstruct [:id, :business, :technical]

  @doc """
  Returns a new `SCOS.RegistryMessage` struct. `SCOS.RegistryMessage.Business` and
  `SCOS.RegistryMessage.Technical` structs will be created along the way.

  Can be created from:
  - `Map` with string keys
  - `Map` with atom keys
  """
  def new(%{"id" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{id: id, business: biz, technical: tech}) do
    struct!(%__MODULE__{}, %{id: id, business: Business.new(biz), technical: Technical.new(tech)})
  end

  def new(msg), do: raise(ArgumentError, "Invalid registry message: #{inspect(msg)}")
end
