defmodule SmartCity.SchemaGeneratorTest do
  use ExUnit.Case
  import Checkov
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
          "type" => "string",
          "ingestion_field_selector" => "key_field"
        }
      ]

      assert actual == expected
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
          "ingestion_field_selector" => "map_field",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field",
              "pii" => "None",
              "type" => "string",
              "ingestion_field_selector" => "sub_key_field"
            }
          ]
        }
      ]

      assert actual == expected
    end

    test "generates a smart city schema from a deeply nested data structure is a map with a map field" do
      data = [
        %{
          "map_field" => %{"sub_key_map" => %{"sub_sub_key" => "devin"}}
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
          "ingestion_field_selector" => "map_field",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_map",
              "pii" => "None",
              "type" => "map",
              "ingestion_field_selector" => "sub_key_map",
              "subSchema" => [
                %{
                  "biased" => "No",
                  "demographic" => "None",
                  "description" => "",
                  "masked" => "N/A",
                  "name" => "sub_sub_key",
                  "pii" => "None",
                  "type" => "string",
                  "ingestion_field_selector" => "sub_sub_key"
                }
              ]
            }
          ]
        }
      ]

      assert actual == expected
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
          "ingestion_field_selector" => "map_field",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field",
              "pii" => "None",
              "type" => "string",
              "ingestion_field_selector" => "sub_key_field"
            },
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field2",
              "pii" => "None",
              "type" => "string",
              "ingestion_field_selector" => "sub_key_field2"
            }
          ]
        }
      ]

      assert actual == expected
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
          "ingestion_field_selector" => "list_field"
        }
      ]

      assert actual == expected
    end

    test "generates a smart city schema from a nested data structure is a list of maps that have lists of" do
      data = [
        %{
          "map_field" => [%{"sub_key_field" => "carl", "sub_map_field" => [%{"sub_sub_key_field" => "dorkly"}]}]
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
          "ingestion_field_selector" => "map_field",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_key_field",
              "pii" => "None",
              "type" => "string",
              "ingestion_field_selector" => "sub_key_field"
            },
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "sub_map_field",
              "pii" => "None",
              "type" => "list",
              "itemType" => "map",
              "ingestion_field_selector" => "sub_map_field",
              "subSchema" => [
                %{
                  "biased" => "No",
                  "demographic" => "None",
                  "description" => "",
                  "masked" => "N/A",
                  "name" => "sub_sub_key_field",
                  "pii" => "None",
                  "type" => "string",
                  "ingestion_field_selector" => "sub_sub_key_field"
                }
              ]
            }
          ]
        }
      ]

      assert actual == expected
    end

    test "generates a smart city schema from a nested data structure with list of lists" do
      data = [
        %{
          "list_field" => [["field1a", "field1b"], ["field2a", "field2b"]]
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
          "itemType" => "list",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "child_of_list",
              "pii" => "None",
              "type" => "list",
              "itemType" => "string",
              "ingestion_field_selector" => "child_of_list"
            },
          ],
          "ingestion_field_selector" => "list_field"
        }
      ]

      assert actual == expected
    end

    test "generates a smart city schema from a complex structure of combined lists and maps" do
      data = [
        %{
          "grandparent" => [
            [
              [
                %{
                  "parentA" => 1,
                  "parentB" => [
                    %{"childA" => "a", "childB" => ["b"]}
                    ]
                  }
              ]
            ]
          ]
        }
      ]

      actual = SchemaGenerator.generate_schema(data)

      expected = [
        %{
          "biased" => "No",
          "demographic" => "None",
          "description" => "",
          "masked" => "N/A",
          "name" => "grandparent",
          "pii" => "None",
          "type" => "list",
          "itemType" => "list",
          "ingestion_field_selector" => "grandparent",
          "subSchema" => [
            %{
              "biased" => "No",
              "demographic" => "None",
              "description" => "",
              "masked" => "N/A",
              "name" => "child_of_list",
              "pii" => "None",
              "type" => "list",
              "itemType" => "list",
              "ingestion_field_selector" => "child_of_list",
              "subSchema" => [
                %{
                  "biased" => "No",
                  "demographic" => "None",
                  "description" => "",
                  "masked" => "N/A",
                  "name" => "child_of_list",
                  "pii" => "None",
                  "type" => "list",
                  "itemType" => "map",
                  "ingestion_field_selector" => "child_of_list",
                  "subSchema" => [
                    %{
                      "biased" => "No",
                      "demographic" => "None",
                      "description" => "",
                      "masked" => "N/A",
                      "name" => "parentA",
                      "pii" => "None",
                      "type" => "integer",
                      "ingestion_field_selector" => "parentA"
                    },
                    %{
                      "biased" => "No",
                      "demographic" => "None",
                      "description" => "",
                      "masked" => "N/A",
                      "name" => "parentB",
                      "pii" => "None",
                      "type" => "list",
                      "itemType" => "map",
                      "ingestion_field_selector" => "parentB",
                      "subSchema" => [
                        %{
                          "biased" => "No",
                          "demographic" => "None",
                          "description" => "",
                          "masked" => "N/A",
                          "name" => "childA",
                          "pii" => "None",
                          "type" => "string",
                          "ingestion_field_selector" => "childA"
                        },
                        %{
                          "biased" => "No",
                          "demographic" => "None",
                          "description" => "",
                          "masked" => "N/A",
                          "name" => "childB",
                          "pii" => "None",
                          "type" => "list",
                          "itemType" => "string",
                          "ingestion_field_selector" => "childB"
                        },
                      ]
                    },
                  ],
                },
              ],
            },
          ],
        }
      ]

      assert actual == expected
    end

    test "interprets itemType of empty lists as strings by default" do
      data = [%{"list_field" => []}]

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
          "ingestion_field_selector" => "list_field"
        }
      ]

      assert actual == expected
    end

    data_test "infers type of #{type}" do
      data = [
        %{
          "key_field" => value
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
          "type" => type,
          "ingestion_field_selector" => "key_field"
        }
      ]

      assert actual == expected

      where([
        [:type, :value],
        ["integer", 9],
        ["float", 3.14],
        ["boolean", false],
        ["date", "2007-10-29"],
        ["timestamp", "2007-10-29T00:00:00.000Z"]
      ])
    end
  end
end
