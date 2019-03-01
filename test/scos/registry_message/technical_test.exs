defmodule SCOS.RegistryMessage.TechnicalTest do
  use ExUnit.Case
  alias SCOS.RegistryMessage.Technical

  describe "new" do
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

    test "returns Technical struct when given string keys" do
      actual =
        Technical.new(%{
          "dataName" => "dataset",
          "orgName" => "org",
          "systemName" => "org__dataset",
          "stream" => false,
          "sourceUrl" => "https://example.com"
        })

      assert actual.systemName == "org__dataset"
      assert actual.queryParams == %{}
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
