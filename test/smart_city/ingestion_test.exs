defmodule SmartCity.IngestionTest do
  use ExUnit.Case
  import Checkov

  alias SmartCity.Ingestion

  setup do
    message = %{
      "id" => "uuid",
      "allow_duplicates" => false,
      "targetDataset" => "dataset",
      "cadence" => 30_000,
      "sourceFormat" => "gtfs",
      "schema" => [],
      "extractSteps" => [],
      "topLevelSelector" => "noodles"
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns Ingestion struct" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          targetDataset: "dataset",
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: []
        })

      assert actual.allow_duplicates == true
      assert actual.targetDataset == "dataset"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.cadence == "never"
      assert actual.schema == []
      assert actual.extractSteps == []
      assert actual.topLevelSelector == nil
    end

    test "is idempotent", %{message: msg} do
      actual = msg |> Ingestion.new() |> Ingestion.new()
      assert actual.allow_duplicates == false
      assert actual.targetDataset == "dataset"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.cadence == 30000
      assert actual.schema == []
      assert actual.extractSteps == []
      assert actual.topLevelSelector == "noodles"
    end

    test "a struct with additional fields is cleaned" do
      actual =
        Ingestion.new(%{
          __struct__: SmartCity.Ingestion,
          id: "uuid",
          targetDataset: "dataset",
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [],
          is_a_good_struct: "no"
        })

      assert actual.targetDataset == "dataset"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.allow_duplicates == true
      assert not Map.has_key?(actual, :is_a_good_struct)
    end

    data_test "field #{field} has a default value of #{inspect(default)}" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          targetDataset: "dataset",
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: []
        })

      assert Map.get(actual, field) == default

      where(
        field: [:schema, :cadence, :extractSteps, :allow_duplicates],
        default: [[], "never", [], true]
      )
    end

    data_test "sourceFormat #{mime_type} based on input type #{extension}" do
      actual =
        Ingestion.new(%{
          id: "uuid",
          targetDataset: "dataset",
          sourceFormat: extension,
          extractSteps: [],
          schema: []
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
      assert actual.targetDataset == "dataset"
      assert actual.sourceFormat == "application/gtfs+protobuf"
      assert actual.schema == []
      assert actual.extractSteps == []
    end

    test "converts deeply nested string keys to atoms" do
      actual =
        Ingestion.new(%{
          "id" => "uuid",
          "targetDataset" => "dataset",
          "sourceFormat" => "gtfs",
          "extractSteps" => [],
          "schema" => [
            %{
              "name" => "field_name",
              "subSchema" => [
                %{"name" => "deep"}
              ]
            }
          ]
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
          targetDataset: "dataset",
          sourceFormat: "gtfs",
          extractSteps: [],
          schema: [
            %{
              "name" => "field_name",
              "subSchema" => [
                %{"name" => "deep"}
              ]
            }
          ]
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

      where(field: ["targetDataset", "sourceFormat"])
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
