defmodule SmartCity.Dataset.TechnicalTest do
  use ExUnit.Case
  import Checkov

  alias SmartCity.Dataset.Technical

  setup do
    message = %{
      "dataName" => "dataset",
      "orgName" => "org",
      "systemName" => "org__dataset",
      "sourceUrl" => "https://example.com",
      "sourceType" => "ingest",
      "sourceHeaders" => %{
        "foo" => "bar"
      }
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns Technical struct" do
      actual =
        Technical.new(%{
          dataName: "dataset",
          orgName: "org",
          systemName: "org__dataset",
          sourceUrl: "https://example.com"
        })

      assert actual.dataName == "dataset"
    end

    test "is idempotent", %{message: tech} do
      actual = tech |> Technical.new() |> Technical.new()
      assert actual.dataName == "dataset"
    end

    test "a poser struct is cleaned" do
      actual =
        Technical.new(%{
          __struct__: SmartCity.Dataset.Technical,
          dataName: "bad_dataset",
          orgName: "org",
          systemName: "org__dataset",
          sourceUrl: "https://example.com",
          is_a_good_struct: "no"
        })

      assert actual.dataName == "bad_dataset"
      assert actual.orgName == "org"
      assert not Map.has_key?(actual, :is_a_good_struct)
    end

    data_test "field #{field} has a default value of #{inspect(default)}" do
      actual =
        Technical.new(%{
          dataName: "dataset",
          orgName: "org",
          systemName: "org__dataset",
          sourceUrl: "https://example.com"
        })

      assert Map.get(actual, field) == default

      where(
        field: [:schema, :sourceType],
        default: [[], "remote"]
      )
    end

    test "returns Technical struct when given string keys", %{message: tech} do
      actual = Technical.new(tech)
      assert actual.systemName == "org__dataset"
      assert actual.sourceQueryParams == %{}
      assert actual.sourceType == "ingest"
    end

    test "converts deeply nested string keys to atoms", %{message: tech} do
      actual = Technical.new(tech)
      assert actual.sourceHeaders.foo == "bar"
    end

    test "converts schema keys to atoms even when the top level is atoms" do
      actual =
        Technical.new(%{
          dataName: "dataset",
          orgName: "org",
          systemName: "org__dataset",
          sourceUrl: "https://example.com",
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

    data_test "throws error when creating Technical struct without required field: #{field}", %{message: tech} do
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete(field)) end

      where(field: ["dataName", "orgName", "systemName", "sourceUrl"])
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
