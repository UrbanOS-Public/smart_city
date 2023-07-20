defmodule SmartCity.UserOrganizationAssociateTest do
  use ExUnit.Case
  use Placebo
  alias SmartCity.UserOrganizationAssociate

  setup do
    string_key_message = %{
      "subject_id" => "Nathaniel",
      "org_id" => 1,
      "email" => "nstevens@example.com"
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{subject_id: "Nathaniel", org_id: 1, email: "nstevens@example.com"}

    invalid_message = %{subject_id: "Nathaniel"}

    {:ok,
     string_key_message: string_key_message,
     json_message: json_message,
     atom_key_message: atom_key_message,
     invalid_message: invalid_message}
  end

  describe "new" do
    test "create new user organization associate message via map with string keys", %{
      string_key_message: string_key_message
    } do
      {:ok, actual} = UserOrganizationAssociate.new(string_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
      assert actual.email == "nstevens@example.com"
    end

    test "create new user organization associate message via json", %{json_message: json_message} do
      {:ok, actual} = UserOrganizationAssociate.new(json_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
      assert actual.email == "nstevens@example.com"
    end

    test "create new user organization associate message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = UserOrganizationAssociate.new(atom_key_message)
      assert actual.subject_id == "Nathaniel"
      assert actual.org_id == 1
      assert actual.email == "nstevens@example.com"
    end

    test "invalid user organization associate message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, _} = UserOrganizationAssociate.new(invalid_message)
    end
  end
end
