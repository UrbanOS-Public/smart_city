defmodule SmartCity.DatasetTest do
  use ExUnit.Case
  use Placebo
  import Checkov
  doctest SmartCity.Dataset
  alias SmartCity.Dataset
  alias SmartCity.Dataset.{Business, Technical, Metadata}

  setup do
    message = %{
      "id" => "uuid",
      "technical" => %{
        "dataName" => "dataset",
        "orgName" => "org",
        "orgId" => "uuid",
        "systemName" => "org__dataset",
        "sourceUrl" => "https://example.com",
        "sourceFormat" => "gtfs",
        "sourceType" => "stream",
        "cadence" => 9000,
        "sourceHeaders" => %{},
        "partitioner" => %{type: nil, query: nil},
        "sourceQueryParams" => %{},
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
      },
      "_metadata" => %{
        "intendedUse" => ["use 1", "use 2", "use 3"],
        "epxectedBenefit" => []
      }
    }

    json = Jason.encode!(message)

    {:ok, message: message, json: json}
  end

  describe "new" do
    test "turns a map with string keys into a Dataset", %{message: map} do
      {:ok, actual} = Dataset.new(map)
      assert actual.id == "uuid"
      assert actual.business.dataTitle == "dataset title"
      assert actual.technical.dataName == "dataset"
    end

    test "turns a map with atom keys into a Dataset", %{message: map} do
      %{"technical" => tech, "business" => biz, "_metadata" => meta} = map
      technical = Technical.new(tech)
      business = Business.new(biz)
      metadata = Metadata.new(meta)

      atom_tech = Map.new(tech, fn {k, v} -> {String.to_atom(k), v} end)
      atom_biz = Map.new(biz, fn {k, v} -> {String.to_atom(k), v} end)
      atom_meta = Map.new(meta, fn {k, v} -> {String.to_atom(k), v} end)
      map = %{id: "uuid", business: atom_biz, technical: atom_tech, _metadata: atom_meta}

      assert {:ok, %Dataset{id: "uuid", business: ^business, technical: ^technical, _metadata: ^metadata}} =
               Dataset.new(map)
    end

    test "can be serialize and deserialized", %{message: message} do
      {:ok, dataset} = Dataset.new(message)
      {:ok, serialized} = Brook.Event.Serializer.serialize(dataset)

      assert {:ok, dataset} == Brook.Event.Deserializer.deserialize(struct(Dataset), serialized)
    end

    test "returns error tuple when creating Dataset without required fields" do
      assert {:error, _} = Dataset.new(%{id: "", technical: ""})
    end

    test "converts a JSON message into a Dataset", %{message: map, json: json} do
      assert Dataset.new(json) == Dataset.new(map)
    end

    test "returns an error tuple when string message can't be decoded" do
      assert {:error, ~s|Invalid Dataset: "Unable to json decode: foo"|} = Dataset.new("foo")
    end

    test "can create a new dataset without _metadata in the schema", %{message: map, json: _json} do
      map_no_meta = Map.delete(map, "_metadata")

      assert {:ok, _} = Dataset.new(map_no_meta)
    end

    test "creates a private dataset by default", %{message: map} do
      %{"technical" => tech} = map
      technical = Technical.new(tech)
      assert technical.private == true
    end
  end

  describe "sourceType function:" do
    data_test "#{inspect(func)} returns #{expected} when sourceType is #{sourceType}", %{message: msg} do
      result =
        msg
        |> put_in(["technical", "sourceType"], sourceType)
        |> Dataset.new()
        |> ok()
        |> func.()

      assert result == expected

      where([
        [:func, :sourceType, :expected],
        [&Dataset.is_stream?/1, "stream", true],
        [&Dataset.is_stream?/1, "remote", false],
        [&Dataset.is_stream?/1, "ingest", false],
        [&Dataset.is_stream?/1, "host", false],
        [&Dataset.is_ingest?/1, "ingest", true],
        [&Dataset.is_ingest?/1, "stream", false],
        [&Dataset.is_ingest?/1, "remote", false],
        [&Dataset.is_ingest?/1, "host", false],
        [&Dataset.is_remote?/1, "remote", true],
        [&Dataset.is_remote?/1, "stream", false],
        [&Dataset.is_remote?/1, "ingest", false],
        [&Dataset.is_remote?/1, "host", false],
        [&Dataset.is_host?/1, "host", true],
        [&Dataset.is_host?/1, "stream", false],
        [&Dataset.is_host?/1, "ingest", false],
        [&Dataset.is_host?/1, "remote", false]
      ])
    end
  end

  defp ok({:ok, value}), do: value
end
