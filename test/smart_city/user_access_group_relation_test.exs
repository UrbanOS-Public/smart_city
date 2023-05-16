defmodule SmartCity.UserAccessGroupRelationTest do
  use ExUnit.Case
  alias SmartCity.UserAccessGroupRelation

  setup do
    string_key_message = %{
      "subject_id" => "Nathaniel",
      "access_group_id" => 1
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{subject_id: "Nathaniel", access_group_id: 1}

    invalid_message = %{subject_id: "Nathaniel"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new user access group relation message via map with string keys", %{
      string_key_message: string_key_message
    } do
      {:ok, actual} = UserAccessGroupRelation.new(string_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.access_group_id == 1
    end

    test "create new user access group relation message via json", %{json_message: json_message} do
      {:ok, actual} = UserAccessGroupRelation.new(json_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.access_group_id == 1
    end

    test "create new user access group relation message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = UserAccessGroupRelation.new(atom_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.access_group_id == 1
    end

    test "invalid user access group relation message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, error} = UserAccessGroupRelation.new(invalid_message)
      assert error == "Invalid user:access_group:relation: %{subject_id: \"Nathaniel\"}"
    end
  end
end
