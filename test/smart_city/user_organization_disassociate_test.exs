defmodule SmartCity.UserOrganizationDisassociateTest do
  use ExUnit.Case
  use Placebo
  alias SmartCity.UserOrganizationDisassociate

  setup do
    string_key_message = %{
      "subject_id" => "Nathaniel",
      "org_id" => 1
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{subject_id: "Nathaniel", org_id: 1}

    invalid_message = %{subject_id: "Nathaniel"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new user organization disassociate message via map with string keys", %{
      string_key_message: string_key_message
    } do
      {:ok, actual} = UserOrganizationDisassociate.new(string_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "create new user organization disassociate message via json", %{json_message: json_message} do
      {:ok, actual} = UserOrganizationDisassociate.new(json_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "create new user organization disassociate message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = UserOrganizationDisassociate.new(atom_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "invalid user organization disassociate message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, _} = UserOrganizationDisassociate.new(invalid_message)
    end
  end
end
