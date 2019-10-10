defmodule SmartCity.DatasetTest do
  use ExUnit.Case
  use Placebo
  import Checkov
  doctest SmartCity.Dataset
  alias SmartCity.Dataset
  alias SmartCity.Dataset.{Business, Technical}

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
        "schema" => []
      },
      "business" => %{
        "dataTitle" => "dataset title",
        "description" => "description",
        "keywords" => ["one", "two"],
        "modifiedDate" => "2019-10-08T17:55:17.198349Z",
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
    test "turns a map with string keys into a Dataset", %{message: map} do
      {:ok, actual} = Dataset.new(map)
      assert actual.id == "uuid"
      assert actual.business.dataTitle == "dataset title"
      assert actual.technical.dataName == "dataset"
    end

    test "turns a map with atom keys into a Dataset", %{message: map} do
      %{"technical" => tech, "business" => biz} = map
      technical = Technical.new(tech)
      business = Business.new(biz)

      atom_tech = Map.new(tech, fn {k, v} -> {String.to_atom(k), v} end)
      atom_biz = Map.new(biz, fn {k, v} -> {String.to_atom(k), v} end)
      map = %{id: "uuid", business: atom_biz, technical: atom_tech}

      assert {:ok, %Dataset{id: "uuid", business: ^business, technical: ^technical}} = Dataset.new(map)
    end

    test "can be serialize and deserialized", %{message: message} do
      {:ok, dataset} = Dataset.new(message)
      {:ok, serialized} = Brook.Serializer.serialize(dataset)

      assert {:ok, dataset} == Brook.Deserializer.deserialize(struct(Dataset), serialized)
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

    test "creates a private dataset by default", %{message: map} do
      %{"technical" => tech} = map
      technical = Technical.new(tech)
      assert technical.private == true
    end

    test "returns an error when modifiedDate is not in the correct format", %{message: map} do
      result =
        map
        |> put_in(["business", "modifiedDate"], "baddate")
        |> Dataset.new()

      assert {:error, [%{"business.modifiedDate" => "Not ISO8601 formatted"}]} == result
    end

    test "returns properly if modifiedDate is blank", %{message: map} do
      result =
        map
        |> put_in(["business", "modifiedDate"], "")
        |> Dataset.new()

      assert elem(result, 0) == :ok
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
