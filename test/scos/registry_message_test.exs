defmodule SCOS.RegistryMessageTest do
  use ExUnit.Case
  alias SCOS.RegistryMessage

  describe "new" do
    setup do
      message = %{
        "id" => "uuid",
        "business" => %{},
        "technical" => %{
          "dataName" => "dataset",
          "orgName" => "org",
          "systemName" => "org__dataset",
          "stream" => false,
          "sourceUrl" => "https://example.com"
        }
      }

      {:ok, message: message}
    end

    test "turns a map with string keys into a RegistryMessage", %{message: map} do
      actual = RegistryMessage.new(map)
      assert actual.id == "uuid"
      assert actual.business == %{}
      assert actual.technical.dataName == "dataset"
    end

    test "turns a map with atom keys into a RegistryMessage", %{message: %{"technical" => tech}} do
      technical = RegistryMessage.Technical.new(tech)

      atom_tech = Map.new(tech, fn {k, v} -> {String.to_atom(k), v} end)
      map = %{id: "uuid", business: %{}, technical: atom_tech}

      assert RegistryMessage.new(map) == %RegistryMessage{id: "uuid", business: %{}, technical: technical}
    end

    test "throws error when creating RegistryMessage without required fields" do
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{business: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", business: ""}) end
    end
  end
end
