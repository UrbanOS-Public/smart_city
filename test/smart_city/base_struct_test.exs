defmodule SmartCity.BaseStructTest do
  use ExUnit.Case

  alias SmartCity.BaseStruct

  describe "new" do
    test "Returns decoded json" do
      assert BaseStruct.new(~s|{"hello": "world"}|) == %{hello: "world"}
    end

    test "Returns error if json is not parsable" do
      assert BaseStruct.new("What do") == "Unable to json decode: What do"
    end

    test "Returns a atomized map when passed a stringified map" do
      assert BaseStruct.new(%{"dataset_id" => "someid"}) == %{dataset_id: "someid"}
    end
  end
end
