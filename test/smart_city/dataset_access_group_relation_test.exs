defmodule SmartCity.DatasetAccessGroupRelationTest do
  use ExUnit.Case
  use Placebo
  alias SmartCity.DatasetAccessGroupRelation

  setup do
    string_key_message = %{
      "dataset_id" => "12345",
      "access_group_id" => 1
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{dataset_id: "67890", access_group_id: 1}

    invalid_message = %{dataset_id: "1701D"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new dataset access group relation message via map with string keys", %{
      string_key_message: string_key_message
    } do
      {:ok, actual} = DatasetAccessGroupRelation.new(string_key_message)
      assert actual.dataset_id == "12345"
      assert actual.access_group_id == 1
    end

    test "create new dataset access group relation message via json", %{json_message: json_message} do
      {:ok, actual} = DatasetAccessGroupRelation.new(json_message)
      assert actual.dataset_id == "12345"
      assert actual.access_group_id == 1
    end

    test "create new dataset access group relation message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = DatasetAccessGroupRelation.new(atom_key_message)
      assert actual.dataset_id == "67890"
      assert actual.access_group_id == 1
    end

    test "invalid dataset access group relation message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, error} = DatasetAccessGroupRelation.new(invalid_message)
      assert error == "Invalid dataset:access_group:relation: %{dataset_id: \"1701D\"}"
    end
  end
end
