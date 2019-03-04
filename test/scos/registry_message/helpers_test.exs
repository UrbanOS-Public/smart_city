defmodule SCOS.RegistryMessage.HelpersTest do
  use ExUnit.Case
  doctest SCOS.RegistryMessage.Helpers
  alias SCOS.RegistryMessage.Helpers

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
end
