defmodule SmartCity.EventLogTest do
  use ExUnit.Case
  use Placebo
  import Checkov

  alias SmartCity.EventLog

  setup do
    timestamp = DateTime.to_iso8601(DateTime.utc_now())
    message = %{
      "title" => "MyTitle",
      "timestamp" => timestamp,
      "source" => "mySource",
      "description" => "myDescription",
      "dataset_id" => "myDatasetId",
      "ingestion_id" => "myIngestionId"
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns EventLog struct" do
      timestamp = DateTime.to_iso8601(DateTime.utc_now())
      actual =
        EventLog.new(%{
          title: "MyTitle",
          timestamp: timestamp,
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId"
        })

      assert actual.title == "MyTitle"
      assert actual.timestamp == timestamp
      assert actual.source == "mySource"
      assert actual.description == "myDescription"
      assert actual.dataset_id == "myDatasetId"
      assert actual.ingestion_id == "myIngestionId"
    end

    test "a struct with additional fields is cleaned" do
      timestamp = DateTime.to_iso8601(DateTime.utc_now())
      actual =
        EventLog.new(%{
          title: "MyTitle",
          timestamp: timestamp,
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId",
          is_a_good_struct: "no"
        })

      assert actual.title == "MyTitle"
      assert actual.timestamp == timestamp
      assert actual.source == "mySource"
      assert actual.description == "myDescription"
      assert actual.dataset_id == "myDatasetId"
      assert actual.ingestion_id == "myIngestionId"
      assert not Map.has_key?(actual, :is_a_good_struct)
    end

    test "requires UTC string format for the timestamp" do

      assert_raise ArgumentError, "Invalid timestamp in event_log: notUTCFormat. Expected ISO8601 string format", fn ->
        EventLog.new(%{
          title: "MyTitle",
          timestamp: "notUTCFormat",
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId",
          is_a_good_struct: "no"
        })
      end
    end

    test "converts a DateTime to ISO8601 string" do
      timestamp = DateTime.utc_now()
      actual =
        EventLog.new(%{
          title: "MyTitle",
          timestamp: timestamp,
          source: "mySource",
          description: "myDescription",
          dataset_id: "myDatasetId",
          ingestion_id: "myIngestionId"
        })

      assert actual.timestamp == DateTime.to_iso8601(timestamp)
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
        field: [:title, :source, :description, :dataset_id],
        default: ["", "", "", ""]
      )
    end

    test "timestamp field has a default value of current time" do
      {:ok, timestamp, _} = DateTime.from_iso8601("2023-07-21T15:58:59.603466Z")
      allow(DateTime.utc_now(), return: timestamp)
      allow(DateTime.to_iso8601(timestamp), return: "2023-07-21T15:58:59.603466Z")

      actual =
        EventLog.new(%{
          title: "",
          timestamp: "",
          source: "",
          description: "",
          dataset_id: ""
        })

      assert actual.timestamp == "2023-07-21T15:58:59.603466Z"
    end

    test "returns EventLog struct when given string keys", %{message: %{"timestamp" => timestamp} = msg} do
      actual = EventLog.new(msg)
      assert actual.title == "MyTitle"
      assert actual.timestamp == timestamp
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
