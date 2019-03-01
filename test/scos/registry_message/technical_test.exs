defmodule SCOS.RegistryMessage.TechnicalTest do
  use ExUnit.Case
  alias SCOS.RegistryMessage.Technical

  describe "new/1" do
    setup do
      message = %{
        "dataName" => "dataset",
        "orgName" => "org",
        "systemName" => "org__dataset",
        "stream" => false,
        "sourceUrl" => "https://example.com",
        "headers" => %{
          "foo" => "bar"
        },
        "transformations" => [%{"foo" => %{"bar" => 1}}],
        "validations" => [1, 2, 3]
      }

      {:ok, message: message}
    end

    test "returns Technical struct" do
      actual =
        Technical.new(%{
          dataName: "dataset",
          orgName: "org",
          systemName: "org__dataset",
          stream: true,
          sourceUrl: "https://example.com"
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

    test "throws error when creating Technical struct without required fields" do
      tech_msg = %{
        dataName: "dataset",
        orgName: "org",
        systemName: "org__dataset",
        stream: true,
        sourceUrl: "https://example.com"
      }

      assert_raise ArgumentError, fn -> Technical.new(tech_msg |> Map.delete(:dataName)) end
      assert_raise ArgumentError, fn -> Technical.new(tech_msg |> Map.delete(:orgName)) end
      assert_raise ArgumentError, fn -> Technical.new(tech_msg |> Map.delete(:systemName)) end
      assert_raise ArgumentError, fn -> Technical.new(tech_msg |> Map.delete(:stream)) end
      assert_raise ArgumentError, fn -> Technical.new(tech_msg |> Map.delete(:sourceUrl)) end
    end
  end
end
