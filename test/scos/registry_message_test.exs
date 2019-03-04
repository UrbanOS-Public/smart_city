defmodule SCOS.RegistryMessageTest do
  use ExUnit.Case
  doctest SCOS.RegistryMessage
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
        },
        "business" => %{
          "dataTitle" => "dataset title",
          "description" => "description",
          "keywords" => ["one", "two"],
          "modifiedDate" => "date",
          "orgTitle" => "org title",
          "contactName" => "contact name",
          "contactEmail" => "contact@email.com",
          "license" => "license",
          "rights" => "rights information"
        }
      }

      {:ok, message: message}
    end

    test "turns a map with string keys into a RegistryMessage", %{message: map} do
      actual = RegistryMessage.new(map)
      assert actual.id == "uuid"
      assert actual.business.dataTitle == "dataset title"
      assert actual.technical.dataName == "dataset"
    end

    test "turns a map with atom keys into a RegistryMessage", %{message: %{"technical" => tech, "business" => biz}} do
      technical = RegistryMessage.Technical.new(tech)
      business = RegistryMessage.Business.new(biz)

      atom_tech = Map.new(tech, fn {k, v} -> {String.to_atom(k), v} end)
      atom_biz = Map.new(biz, fn {k, v} -> {String.to_atom(k), v} end)
      map = %{id: "uuid", business: atom_biz, technical: atom_tech}

      assert RegistryMessage.new(map) == %RegistryMessage{id: "uuid", business: business, technical: technical}
    end

    test "throws error when creating RegistryMessage without required fields" do
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{business: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", business: ""}) end
    end
  end
end
