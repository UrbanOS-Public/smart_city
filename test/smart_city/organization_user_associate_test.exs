defmodule SmartCity.OrganizationUserAssociateTest do
  use ExUnit.Case
  use Placebo
  alias SmartCity.OrganizationUserAssociate

  setup do
    string_key_message = %{
      "user_id" => "Nathaniel",
      "org_id" => 1
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{user_id: "Nathaniel", org_id: 1}

    invalid_message = %{user_id: "Nathaniel"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new organization user associate message via map with string keys", %{
      string_key_message: string_key_message
    } do
      {:ok, actual} = OrganizationUserAssociate.new(string_key_message)
      assert actual.user_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "create new organization user associate message via json", %{json_message: json_message} do
      {:ok, actual} = OrganizationUserAssociate.new(json_message)
      assert actual.user_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "create new organization user associate message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = OrganizationUserAssociate.new(atom_key_message)
      assert actual.user_id == "Nathaniel"
      assert actual.org_id == 1
    end

    test "invalid organization user associate message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, _} = OrganizationUserAssociate.new(invalid_message)
    end
  end
end
