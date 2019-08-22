defmodule SmartCity.Event.BaseEvent do
  @moduledoc """
  This module provides deserialization and atomization for event structs
  """
  alias SmartCity.Helpers

  @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
  def new(msg) when is_binary(msg) do
    case Jason.decode(msg, keys: :atoms) do
      {:ok, decoded} -> decoded
      _ -> "Unable to json decode: #{msg}"
    end
  end

  def new(%{"id" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
  end

  def new(msg) do
    msg
  end
end
