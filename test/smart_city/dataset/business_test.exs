defmodule SmartCity.Dataset.BusinessTest do
  use ExUnit.Case
  doctest SmartCity.Dataset.Business
  alias SmartCity.Dataset.Business

  setup do
    message = %{
      dataTitle: "dataset title",
      description: "description",
      modifiedDate: "2019-01-01",
      orgTitle: "org title",
      contactName: "contact name",
      contactEmail: "contact@email.com",
      license: "license"
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns Business struct", %{message: biz} do
      actual = Business.new(biz)
      assert actual.dataTitle == "dataset title"
      assert actual.orgTitle == "org title"
    end

    test "returns default values for non-required fields", %{message: biz} do
      actual = Business.new(biz)
      assert actual.keywords == nil
      assert actual.rights == nil
    end

    test "allows blank modified dates", %{message: biz} do
      blank_date_map = Map.put(biz, :modifiedDate, "")

      blank_date_struct = Business.new(blank_date_map)

      assert blank_date_struct.modifiedDate == ""
    end

    test "sets modified date to empty string if modified date is nil", %{message: biz} do
      nil_date_map = Map.put(biz, :modifiedDate, nil)

      nil_date_struct = Business.new(nil_date_map)

      assert nil_date_struct.modifiedDate == ""
    end

    test "set modified date to empty string for invalid modified dates", %{message: biz} do
      invalid_date_map = Map.put(biz, :modifiedDate, "hello date")

      invalid_date_struct = Business.new(invalid_date_map)

      assert invalid_date_struct.modifiedDate == ""
    end

    test "doesnt mutate valid iso 8601 dates", %{message: biz} do
      valid_date_map = Map.put(biz, :modifiedDate, "2019-12-07")

      valid_date_struct = Business.new(valid_date_map)

      assert valid_date_struct.modifiedDate == "2019-12-07"
    end

    test "converts map with string keys to Business struct" do
      actual =
        Business.new(%{
          "dataTitle" => "dataset title",
          "description" => "description",
          "keywords" => ["one", "two"],
          "modifiedDate" => "2010-10-10",
          "orgTitle" => "org title",
          "contactName" => "contact name",
          "contactEmail" => "contact@email.com",
          "license" => "license",
          "rights" => "rights information"
        })

      assert actual.dataTitle == "dataset title"
      assert actual.license == "license"
      assert actual.keywords == ["one", "two"]
    end

    test "throws error when creating Business struct without required fields", %{message: msg} do
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:dataTitle)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:description)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:modifiedDate)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:orgTitle)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:contactName)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:contactEmail)) end
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
