defmodule SCOS.RegistryMessageTest do
  use ExUnit.Case
  alias SCOS.RegistryMessage

  describe "new" do
    test "turns a map with string keys into a RegistryMessage" do
      map = %{"id" => "uuid", "business" => %{}, "technical" => %{}}
      assert RegistryMessage.new(map) == %RegistryMessage{id: "uuid", business: %{}, technical: %{}}
    end

    test "turns a map with atom keys into a RegistryMessage" do
      map = %{id: "uuid", business: %{}, technical: %{}}
      assert RegistryMessage.new(map) == %RegistryMessage{id: "uuid", business: %{}, technical: %{}}
    end

    test "throws error when creating RegistryMessage without required fields" do
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{business: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", technical: ""}) end
      assert_raise ArgumentError, fn -> RegistryMessage.new(%{id: "", business: ""}) end
    end
  end
end
