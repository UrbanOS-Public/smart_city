defmodule SCOS.RegistryMessage.TechnicalTest do
  use ExUnit.Case
  doctest SCOS.RegistryMessage.Technical
  alias SCOS.RegistryMessage.Technical

  setup do
    message = %{
      "dataName" => "dataset",
      "orgName" => "org",
      "systemName" => "org__dataset",
      "stream" => false,
      "sourceUrl" => "https://example.com",
      "sourceFormat" => "gtfs",
      "headers" => %{
        "foo" => "bar"
      },
      "transformations" => [%{"foo" => %{"bar" => 1}}],
      "validations" => [1, 2, 3]
    }

    {:ok, message: message}
  end

  describe "new/1" do
    test "returns Technical struct" do
      actual =
        Technical.new(%{
          dataName: "dataset",
          orgName: "org",
          systemName: "org__dataset",
          stream: true,
          sourceUrl: "https://example.com",
          sourceFormat: "gtfs"
        })

      assert actual.dataName == "dataset"
      assert actual.schema == []
    end

    test "returns Technical struct when given string keys", %{message: tech} do
      actual = Technical.new(tech)
      assert actual.systemName == "org__dataset"
      assert actual.queryParams == %{}
    end

    test "converts deeply nested string keys to atoms", %{message: tech} do
      actual = Technical.new(tech)
      assert actual.headers.foo == "bar"
      assert List.first(actual.transformations).foo.bar == 1
    end

    test "throws error when creating Technical struct without required fields", %{message: tech} do
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete("dataName")) end
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete("orgName")) end
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete("systemName")) end
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete("stream")) end
      assert_raise ArgumentError, fn -> Technical.new(tech |> Map.delete("sourceUrl")) end
    end
  end

  describe "struct" do
    test "can be encoded to JSON", %{message: message} do
      json = Jason.encode!(message)
      assert is_binary(json)
    end
  end
end
