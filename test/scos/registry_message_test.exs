defmodule SCOS.RegistryMessageTest do
  use ExUnit.Case
  doctest SCOS.RegistryMessage
  alias SCOS.RegistryMessage

  setup do
    message = %{
      "id" => "uuid",
      "technical" => %{
        "dataName" => "dataset",
        "orgName" => "org",
        "systemName" => "org__dataset",
        "stream" => false,
        "sourceUrl" => "https://example.com",
        "cadence" => 9000,
        "headers" => %{},
        "queryParams" => %{},
        "transformations" => [],
        "validations" => [],
        "schema" => []
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
        "rights" => "rights information",
        "homepage" => ""
      }
    }

    json = Jason.encode!(message)

    {:ok, message: message, json: json}
  end

  describe "new" do
    test "turns a map with string keys into a RegistryMessage", %{message: map} do
      {:ok, actual} = RegistryMessage.new(map)
      assert actual.id == "uuid"
      assert actual.business.dataTitle == "dataset title"
      assert actual.technical.dataName == "dataset"
    end

    test "turns a map with atom keys into a RegistryMessage", %{message: map} do
      %{"technical" => tech, "business" => biz} = map
      technical = RegistryMessage.Technical.new(tech)
      business = RegistryMessage.Business.new(biz)

      atom_tech = Map.new(tech, fn {k, v} -> {String.to_atom(k), v} end)
      atom_biz = Map.new(biz, fn {k, v} -> {String.to_atom(k), v} end)
      map = %{id: "uuid", business: atom_biz, technical: atom_tech}

      {:ok, actual} = RegistryMessage.new(map)

      assert actual == %RegistryMessage{id: "uuid", business: business, technical: technical}
    end

    test "returns error tuple when creating RegistryMessage without required fields" do
      {:error, reason} = RegistryMessage.new(%{id: "", technical: ""})
      assert Regex.match?(~r/Invalid registry message:/, reason)
    end

    test "converts a JSON message into a RegistryMessage", %{message: map, json: json} do
      assert RegistryMessage.new(json) == RegistryMessage.new(map)
    end
  end

  describe "encode/1" do
    test "JSON encodes the RegistryMessage", %{message: message, json: json} do
      {:ok, struct} = RegistryMessage.new(message)
      {:ok, encoded} = RegistryMessage.encode(struct)

      assert encoded == json
    end

    test "returns error tuple if argument is not a RegistryMessage" do
      assert_raise ArgumentError, fn ->
        RegistryMessage.encode(%{a: "b"})
      end
    end
  end

  describe "encode!/1" do
    test "JSON encodes the RegistryMessage without OK tuple", %{message: message, json: json} do
      {:ok, struct} = RegistryMessage.new(message)
      assert RegistryMessage.encode!(struct) == json
    end

    test "raises Jason.EncodeError if message can't be encoded", %{message: message} do
      {:ok, invalid} =
        message
        |> Map.update!("id", fn _ -> "\xFF" end)
        |> RegistryMessage.new()

      assert_raise Jason.EncodeError, fn ->
        RegistryMessage.encode!(invalid)
      end
    end

    test "raises ArgumentError if argument is not a RegistryMessage" do
      assert_raise ArgumentError, fn ->
        RegistryMessage.encode(%{a: "b"})
      end
    end
  end
end
