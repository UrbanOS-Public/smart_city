defmodule SmartCity.EventLogTest do
  use ExUnit.Case
  import Checkov

  alias SmartCity.EventLog

  setup do
    message = %{
      "title" => "MyTitle",
      "timestamp" => "myTimestamp",
      "source" => "mySource",
      "description" => "myDescription",
      "dataset_id" => "myDatasetId",
      "ingestion_id" => "myIngestionId"
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns EventLog struct" do
      actual =
        EventLog.new(%{
          title: "MyTitle",
          timestamp: "myTimestamp",
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId"
        })

      assert actual.title == "MyTitle"
      assert actual.timestamp == "myTimestamp"
      assert actual.source == "mySource"
      assert actual.description == "myDescription"
      assert actual.dataset_id == "myDatasetId"
      assert actual.ingestion_id == "myIngestionId"
    end

    test "a struct with additional fields is cleaned" do
      actual =
        EventLog.new(%{
          title: "MyTitle",
          timestamp: "myTimestamp",
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId",
          is_a_good_struct: "no"
        })

      assert actual.title == "MyTitle"
      assert actual.timestamp == "myTimestamp"
      assert actual.source == "mySource"
      assert actual.description == "myDescription"
      assert actual.dataset_id == "myDatasetId"
      assert actual.ingestion_id == "myIngestionId"
      assert not Map.has_key?(actual, :is_a_good_struct)
    end

    data_test "field #{field} has a default value of #{inspect(default)}" do
      actual =
        EventLog.new(%{
          title: "",
          timestamp: "",
          source: "",
          description: "",
          dataset_id: ""
        })

      assert Map.get(actual, field) == default

      where(
        field: [:title, :timestamp, :source, :description, :dataset_id],
        default: ["", "", "", "", ""]
      )
    end

    test "returns Ingestion struct when given string keys", %{message: msg} do
      actual = EventLog.new(msg)
      assert actual.title == "MyTitle"
      assert actual.timestamp == "myTimestamp"
      assert actual.source == "mySource"
      assert actual.description == "myDescription"
      assert actual.dataset_id == "myDatasetId"
      assert actual.ingestion_id == "myIngestionId"
    end

    data_test "throws error when creating EventLog struct without required field: #{field}", %{message: msg} do
      assert_raise ArgumentError, fn -> EventLog.new(msg |> Map.delete(field)) end

      where(field: ["title", "timestamp", "source", "description", "dataset_id"])
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
