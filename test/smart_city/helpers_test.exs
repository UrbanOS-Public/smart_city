defmodule SmartCity.HelpersTest do
  use ExUnit.Case
  doctest SmartCity.Helpers
  alias SmartCity.Helpers

  describe "to_atom_keys/1" do
    test "converts top level string keys to atoms" do
      assert Helpers.to_atom_keys(%{"foo" => "bar"}) == %{foo: "bar"}
    end

    test "converts top level keys in a list to atoms" do
      input = %{"list" => [%{"foo" => "bar"}, %{"abc" => "xyz"}]}
      expected = %{list: [%{foo: "bar"}, %{abc: "xyz"}]}

      assert Helpers.to_atom_keys(input) == expected
    end

    test "converts nested keys to atoms" do
      input = %{"foo" => %{"bar" => "baz"}}
      expected = %{foo: %{bar: "baz"}}

      assert Helpers.to_atom_keys(input) == expected
    end

    test "converts nested keys in a nested list" do
      input = %{
        "foo" => %{
          "bar" => [%{"baz" => [%{"abc" => 123}]}]
        }
      }

      expected = %{
        foo: %{
          bar: [%{baz: [%{abc: 123}]}]
        }
      }

      assert Helpers.to_atom_keys(input) == expected
    end

    test "handles a map with atom keys" do
      input = %{foo: 1}
      assert Helpers.to_atom_keys(input) == input
    end
  end

  describe "deep_merge" do
    test "merges two maps" do
      left = Map.new(%{one: 1, two: 2})
      right = Map.new(%{one: "one"})
      assert Helpers.deep_merge(left, right) == %{one: "one", two: 2}
    end

    test "merges maps that are children in other maps" do
      left = Map.new(%{stuff: %{one: 1, two: 2, stuff: %{one: 1, two: 2}}})
      right = Map.new(%{stuff: %{one: "one", stuff: %{two: "two"}}})

      assert Helpers.deep_merge(left, right) == %{stuff: %{one: "one", two: 2, stuff: %{one: 1, two: "two"}}}
    end
  end
end
