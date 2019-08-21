defmodule SmartCity.Event.BaseEvent do
  @moduledoc """
  Macro for repeated code to deserialize and atomize event structs
  """
  @callback create(%{required(atom()) => term()}) :: term()
  alias SmartCity.Helpers

  defmacro __using__(_opts) do
    quote do
      @behaviour SmartCity.Event.BaseEvent

      @spec new(String.t() | map()) :: {:ok, map()} | {:error, term()}
      def new(msg) when is_binary(msg) do
        with {:ok, decoded} <- Jason.decode(msg, keys: :atoms) do
          create(decoded)
        end
      end

      def new(%{"id" => _} = msg) do
        msg
        |> Helpers.to_atom_keys()
        |> create()
      end

      def new(msg) do
        create(msg)
      end
    end
  end
end
