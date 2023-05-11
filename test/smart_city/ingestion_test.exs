defmodule SmartCity.IngestionTest do
  use ExUnit.Case
  import Checkov

  alias SmartCity.Ingestion

  setup do
    message = %{
      "id" => "uuid",
      "name" => "name",
      "allow_duplicates" => false,
      "targetDatasets" => ["dataset1", "dataset2"],
      "cadence" => 30_000,
      "sourceFormat" => "gtfs",
      "schema" => [],
      "extractSteps" => [],
      "topLevelSelector" => "noodles",
      "transformations" => [
        %{
          "id" => "transformation_id",
          "sequence" => 1,
          "type" => "regex_extract",
          "name" => "name",
          "parameters" => %{
            "sourceField" => "phone_number",
            "targetField" => "area_code",
            "regex" => "^\\((\\d{3})\\)"
          }
        }
      ]
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns Ingestion struct" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          name: "name",
          targetDatasets: ["dataset1", "dataset2"],
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [],
          transformations: []
        })

      assert actual.allow_duplicates == true
      assert actual.targetDatasets == ["dataset1", "dataset2"]
      assert actual.name == "name"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.cadence == "never"
      assert actual.schema == []
      assert actual.extractSteps == []
      assert actual.topLevelSelector == nil
      assert actual.transformations == []
    end

    test "can handle deprecated targetDataset field" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          name: "name",
          targetDataset: "ds1",
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [],
          transformations: []
        })

      assert actual.allow_duplicates == true
      assert actual.targetDatasets == ["ds1"]
      assert actual.name == "name"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.cadence == "never"
      assert actual.schema == []
      assert actual.extractSteps == []
      assert actual.topLevelSelector == nil
      assert actual.transformations == []
    end

    test "is idempotent", %{message: msg} do
      actual = msg |> Ingestion.new() |> Ingestion.new()
      assert actual.allow_duplicates == false
      assert actual.targetDatasets == ["dataset1", "dataset2"]
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.cadence == 30_000
      assert actual.schema == []
      assert actual.extractSteps == []
      assert actual.topLevelSelector == "noodles"
      transformation = List.first(actual.transformations)
      assert transformation.type == "regex_extract"
      assert transformation.parameters.sourceField == "phone_number"
      assert transformation.parameters.targetField == "area_code"
      assert transformation.parameters.regex == "^\\((\\d{3})\\)"
    end

    test "a struct with additional fields is cleaned" do
      actual =
        Ingestion.new(%{
          __struct__: SmartCity.Ingestion,
          id: "uuid",
          name: "name",
          targetDatasets: ["dataset1", "dataset2"],
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [],
          is_a_good_struct: "no",
          transformations: []
        })

      assert actual.targetDatasets == ["dataset1", "dataset2"]
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.allow_duplicates == true
      assert not Map.has_key?(actual, :is_a_good_struct)
    end

    data_test "field #{field} has a default value of #{inspect(default)}" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          name: "name",
          targetDatasets: ["dataset1", "dataset2"],
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [],
          transformations: []
        })

      assert Map.get(actual, field) == default

      where(
        field: [:schema, :cadence, :extractSteps, :allow_duplicates, :transformations],
        default: [[], "never", [], true, []]
      )
    end

    data_test "sourceFormat #{mime_type} based on input type #{extension}" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          name: "name",
          targetDatasets: ["dataset1", "dataset2"],
          sourceFormat: extension,
          extractSteps: [],
          schema: [],
          transformations: []
        })

      assert Map.get(actual, :sourceFormat) == mime_type

      where([
        [:extension, :mime_type],
        ["gtfs", "application/gtfs+protobuf"],
        ["csv", "text/csv"],
        ["zip", "application/zip"],
        ["kml", "application/vnd.google-earth.kml+xml"],
        ["json", "application/json"],
        ["xml", "text/xml"]
      ])
    end

    test "returns Ingestion struct when given string keys", %{message: msg} do
      actual = Ingestion.new(msg)
      assert actual.allow_duplicates == false
      assert actual.cadence == 30_000
      assert actual.targetDatasets == ["dataset1", "dataset2"]
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.schema == []
      assert actual.extractSteps == []
      transformation = List.first(actual.transformations)
      assert transformation.id == "transformation_id"
      assert transformation.sequence == 1
      assert transformation.type == "regex_extract"
      assert transformation.parameters.sourceField == "phone_number"
      assert transformation.parameters.targetField == "area_code"
      assert transformation.parameters.regex == "^\\((\\d{3})\\)"
    end

    test "converts deeply nested string keys to atoms" do
      actual =
        Ingestion.new(%{
          "id" => "uuid",
          "name" => "name",
          "targetDatasets" => ["dataset1", "dataset2"],
          "sourceFormat" => "gtfs",
          "extractSteps" => [],
          "schema" => [
            %{
              "name" => "field_name",
              "subSchema" => [
                %{"name" => "deep"}
              ]
            }
          ],
          "transformations" => []
        })

      assert List.first(actual.schema) == %{
               name: "field_name",
               subSchema: [
                 %{name: "deep"}
               ]
             }
    end

    test "converts schema keys to atoms even when the top level is atoms" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          name: "name",
          targetDatasets: ["dataset1", "dataset2"],
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [
            %{
              "name" => "field_name",
              "subSchema" => [
                %{"name" => "deep"}
              ]
            }
          ],
          transformations: []
        })

      assert List.first(actual.schema) == %{
               name: "field_name",
               subSchema: [
                 %{name: "deep"}
               ]
             }
    end

    data_test "throws error when creating Ingestion struct without required field: #{field}", %{message: msg} do
      assert_raise ArgumentError, fn -> Ingestion.new(msg |> Map.delete(field)) end

      where(field: ["targetDatasets", "sourceFormat"])
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
