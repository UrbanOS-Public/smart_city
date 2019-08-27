defmodule SmartCity.Dataset.MetadataTest do
  use ExUnit.Case
  doctest SmartCity.Dataset.Metadata
  alias SmartCity.Dataset.Metadata

  setup do
    message = %{
      "intendedUse" => ["use 1", "use 2", "use 3"],
      "expectedBenefit" => ["benefit 1", "benefit 2", "benefit 3"]
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns _metadata struct when keys are atoms" do
      actual =
        Metadata.new(%{
          intendedUse: ["use 1", "use 2", "use 3"],
          expectedBenefit: ["benefit 1", "benefit 2", "benefit 3"]
        })

      assert actual.intendedUse == ["use 1", "use 2", "use 3"]
      assert actual.expectedBenefit == ["benefit 1", "benefit 2", "benefit 3"]
    end

    test "returns _metadata struct when keys are strings", %{message: meta} do
      actual = Metadata.new(meta)

      assert actual.intendedUse == ["use 1", "use 2", "use 3"]
      assert actual.expectedBenefit == ["benefit 1", "benefit 2", "benefit 3"]
    end

    test "returns default value for non-required fields" do
      actual = Metadata.new(%{})

      assert actual.intendedUse == []
      assert actual.expectedBenefit == []
    end

    test "Additional fields not in the struct are ignored" do
      actual =
        Metadata.new(%{
          "intendedUse" => ["use 1", "use 2", "use 3"],
          "expectedBenefit" => ["benefit 1", "benefit 2", "benefit 3"],
          "fieldDoesntExist" => "somevalue"
        })

      assert actual.intendedUse == ["use 1", "use 2", "use 3"]
      assert Map.has_key?(actual, :fieldDoesntExist) == false
    end

    test "throws when input is invalid" do
      assert_raise ArgumentError, fn -> Metadata.new(1234) end
      assert_raise ArgumentError, fn -> Metadata.new("invalid input") end
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
