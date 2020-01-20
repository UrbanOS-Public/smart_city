defmodule SmartCity.SchemaGeneratorTest do
  use ExUnit.Case
  alias SmartCity.SchemaGenerator

  describe "generate_schema/1" do
    test "generates a smart city schema from a map with a single string field" do
      data = [
        %{
          "key_field" => "Bob"
        }
      ]

      actual = SchemaGenerator.generate_schema(data)

      expected = [
        %{
          "biased" => "No",
          "demographic" => "None",
          "description" => "",
          "masked" => "N/A",
          "name" => "key_field",
          "pii" => "None",
          "type" => "string"
        }
      ]

      assert actual==expected
    end

    test "generates a smart city schema from a nested data structure is a map" do
      data = [
        %{
          "map_field" => %{"sub_key_field" => "frank"}
        }
      ]

      actual = SchemaGenerator.generate_schema(data)

      expected = [
        %{
          "biased" => "No",
          "demographic" => "None",
          "description" => "",
          "masked" => "N/A",
          "name" => "map_field",
          "pii" => "None",
          "type" => "map",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field",
              "pii" => "None",
              "type" => "string"
            }
          ]
        }
      ]

      assert actual==expected
    end

    test "generates a smart city schema from a nested data structure is a list of maps" do
      data = [
        %{
          "map_field" => [%{"sub_key_field" => "carl", "sub_key_field2" => "123"}]
        }
      ]

      actual = SchemaGenerator.generate_schema(data)

      expected = [
        %{
          "biased" => "No",
          "demographic" => "None",
          "description" => "",
          "masked" => "N/A",
          "name" => "map_field",
          "pii" => "None",
          "type" => "list",
          "itemType" => "map",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field",
              "pii" => "None",
              "type" => "string"
            },
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field2",
              "pii" => "None",
              "type" => "string"
            }
          ]
        }
      ]

      assert actual==expected
    end

    test "generates a smart city schema from a nested data structure is a list of strings" do
      data = [
        %{
          "list_field" => ["a", "5", "k"]
        }
      ]

      actual = SchemaGenerator.generate_schema(data)

      expected = [
        %{
          "biased" => "No",
          "demographic" => "None",
          "description" => "",
          "masked" => "N/A",
          "name" => "list_field",
          "pii" => "None",
          "type" => "list",
          "itemType" => "string",
        }
      ]

      assert actual==expected
    end
  end
end
