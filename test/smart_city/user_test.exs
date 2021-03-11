defmodule SmartCity.UserTest do
  use ExUnit.Case
  use Placebo
  alias SmartCity.User

  setup do
    string_key_message = %{
      "subject_id" => "Cam",
      "email" => "cam@cam.com"
    }

    json_message = Jason.encode!(string_key_message)

    atom_key_message = %{subject_id: "Cam", email: "cam@cam.com"}

    invalid_message = %{subject_id: "Cam"}

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
      {:ok, actual} = User.new(string_key_message)
      assert actual.subject_id == "Cam"
      assert actual.email == "cam@cam.com"
    end

    test "create new user organization associate message via json", %{json_message: json_message} do
      {:ok, actual} = User.new(json_message)
      assert actual.subject_id == "Cam"
      assert actual.email == "cam@cam.com"
    end

    test "create new user organization associate message via map with atom keys", %{
      atom_key_message: atom_key_message
    } do
      {:ok, actual} = User.new(atom_key_message)
      assert actual.subject_id == "Cam"
      assert actual.email == "cam@cam.com"
    end

    test "invalid user organization associate message fails to create", %{
      invalid_message: invalid_message
    } do
      assert {:error, _} = User.new(invalid_message)
    end
  end
end
