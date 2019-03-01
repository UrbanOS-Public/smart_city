defmodule SCOS.RegistryMessage.BusinessTest do
  use ExUnit.Case
  alias SCOS.RegistryMessage.Business

  describe "new/1" do
    setup do
      message = %{
        dataTitle: "dataset title",
        description: "description",
        modifiedDate: "date",
        orgTitle: "org title",
        contactName: "contact name",
        contactEmail: "contact@email.com",
        license: "license",
      }

      {:ok, message: message}
    end

    test "returns Business struct", %{message: biz} do
      actual = Business.new(biz)
      assert actual.dataTitle == "dataset title"
      assert actual.orgTitle == "org title"
    end

    test "returns default values for non-required fields", %{message: biz} do
      actual = Business.new(biz)
      assert actual.keywords == []
      assert actual.rights == ""
    end

    test "converts map with string keys to Business struct" do
      actual =
        Business.new(%{
          "dataTitle" => "dataset title",
          "description" => "description",
          "keywords" => ["one", "two"],
          "modifiedDate" => "date",
          "orgTitle" => "org title",
          "contactName" => "contact name",
          "contactEmail" => "contact@email.com",
          "license" => "license",
          "rights" => "rights information"
        })

      assert actual.dataTitle == "dataset title"
      assert actual.keywords == ["one", "two"]
    end

    test "throws error when creating Business struct without required fields", %{message: msg} do
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:dataTitle)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:description)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:modifiedDate)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:orgTitle)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:contactName)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:contactEmail)) end
      assert_raise ArgumentError, fn -> Business.new(msg |> Map.delete(:license)) end
    end
  end
end
