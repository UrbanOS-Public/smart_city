defmodule SmartCity.AccessGroupTest do
  use ExUnit.Case

  alias SmartCity.AccessGroup

  setup do
    string_key_message = %{
      "id" => "12345-6789",
      "name" => "This is an Access Group",
      "description" => "some description"
    }

    json_message = Jason.encode!(%{"id" => "12345", "name" => "This is another access group"})

    atom_key_message = %{id: "56789", name: "This is an access group", description: "description"}

    invalid_message = %{id: "56789"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new access group message via map with string keys", %{string_key_message: string_key_message} do
      {:ok, actual} = AccessGroup.new(string_key_message)
      assert actual.id == string_key_message["id"]
      assert actual.name == string_key_message["name"]
      assert actual.description == string_key_message["description"]
    end

    test "create new access group message via json", %{json_message: json_message} do
      expected_values = Jason.decode!(json_message)
      {:ok, actual} = AccessGroup.new(json_message)
      assert actual.id == expected_values["id"]
      assert actual.name == expected_values["name"]
      assert actual.description == nil
    end

    test "create new access group message via map with atom keys", %{atom_key_message: atom_key_message} do
      {:ok, actual} = AccessGroup.new(atom_key_message)
      assert actual.id == atom_key_message.id
      assert actual.name == atom_key_message.name
      assert actual.description == atom_key_message.description
    end

    test "invalid access group message fails to create", %{invalid_message: invalid_message} do
      assert {:error, error} = AccessGroup.new(invalid_message)
      assert error == "Invalid access group: %{id: \"56789\"}"
    end
  end
end
