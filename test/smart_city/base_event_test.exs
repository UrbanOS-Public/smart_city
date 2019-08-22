defmodule SmartCity.Event.BaseEventTest do
  use ExUnit.Case
  use Placebo

  alias SmartCity.Event.BaseEvent

  describe "new" do
    test "Returns decoded json" do
      assert BaseEvent.new(~s|{"hello": "world"}|) == %{hello: "world"}
    end

    test "Returns error if json is not parsable" do
      assert BaseEvent.new("What do") == "Unable to json decode: What do"
    end

    test "Returns a atomized map when passed a stringified map" do
      assert BaseEvent.new(%{"dataset_id" => "someid"}) == %{dataset_id: "someid"}
    end
  end
end
