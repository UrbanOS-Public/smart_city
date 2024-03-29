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

    test "handles a map with atom keys that has nested string keys" do
      input = %{foo: 1, bar: %{"baz" => "derp"}}
      assert Helpers.to_atom_keys(input) == %{foo: 1, bar: %{baz: "derp"}}
    end

    test "handles a map with atom keys that has a list of objects with string keys" do
      input = %{foo: 1, bar: [%{"baz" => "derp"}]}
      assert Helpers.to_atom_keys(input) == %{foo: 1, bar: [%{baz: "derp"}]}
    end

    test "handles a list of maps with nested string keys" do
      input = [%{foo: 1, bar: [%{"baz" => "derp"}]}]
      assert Helpers.to_atom_keys(input) == [%{foo: 1, bar: [%{baz: "derp"}]}]
    end
  end

  describe "to_string_keys/1" do
    test "converts top level atom keys to strings" do
      assert Helpers.to_string_keys(%{foo: "bar"}) == %{"foo" => "bar"}
    end

    test "converts top level keys in a list to strings" do
      input = %{list: [%{foo: "bar"}, %{abc: "xyz"}]}
      expected = %{"list" => [%{"foo" => "bar"}, %{"abc" => "xyz"}]}

      assert Helpers.to_string_keys(input) == expected
    end

    test "converts nested keys to strings" do
      input = %{foo: %{bar: "baz"}}
      expected = %{"foo" => %{"bar" => "baz"}}

      assert Helpers.to_string_keys(input) == expected
    end

    test "converts nested keys in a nested list" do
      input = %{
        foo: %{
          bar: [%{baz: [%{abc: 123}]}]
        }
      }

      expected = %{
        "foo" => %{
          "bar" => [%{"baz" => [%{"abc" => 123}]}]
        }
      }

      assert Helpers.to_string_keys(input) == expected
    end

    test "handles a map with string keys" do
      input = %{"foo" => 1}
      assert Helpers.to_string_keys(input) == input
    end

    test "handles a map with string keys that has nested atom keys" do
      input = %{"foo" => 1, "bar" => %{baz: "derp"}}
      expected = %{"foo" => 1, "bar" => %{"baz" => "derp"}}
      assert Helpers.to_string_keys(input) == expected
    end

    test "handles a map with string keys that has a list of objects with atom keys" do
      input = %{"foo" => 1, "bar" => [%{baz: "derp"}]}
      expected = %{"foo" => 1, "bar" => [%{"baz" => "derp"}]}
      assert Helpers.to_string_keys(input) == expected
    end

    test "handles a list of maps with nested atom keys" do
      input = [%{"foo" => 1, "bar" => [%{baz: "derp"}]}]
      expected = [%{"foo" => 1, "bar" => [%{"baz" => "derp"}]}]
      assert Helpers.to_string_keys(input) == expected
    end
  end

  describe "mime_type/1" do
    test "converts file extension to recognized type" do
      assert "application/json" == Helpers.mime_type("json")
    end

    test "recognizes upper-case mime types" do
      assert "application/json" == Helpers.mime_type("JSON")
    end

    test "passes through valid recognized mime types" do
      assert "text/csv" == Helpers.mime_type("text/csv")
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

    test "overrides default map with overrride map when override is empty" do
      left = Map.new(%{stuff: %{one: 1, two: 2, stuff: %{one: 1, two: 2}}})
      right = %{}

      assert Helpers.deep_merge(left, right) == %{}
    end
  end
end
