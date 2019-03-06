defmodule SCOS.DataMessageTest do
  use ExUnit.Case
  doctest SCOS.DataMessage

  alias SCOS.DataMessage
  alias SCOS.DataMessage.Timing

  describe "parse_message" do
    test "throws error without required keys" do
      value = "{}"

      assert_raise ArgumentError, fn -> DataMessage.parse_message(value) end
    end

    test "creates a DataMessage struct with required keys" do
      value = ~s({"_metadata":[],"dataset_id":"abc","operational":{},"payload":"whatever"})

      assert %DataMessage{
               dataset_id: "abc",
               payload: "whatever",
               _metadata: [],
               operational: %{}
             } = DataMessage.parse_message(value)
    end
  end

  describe "encode" do
    test "encodes to JSON" do
      data_message = %DataMessage{
        dataset_id: "abc",
        payload: "whatever",
        _metadata: [],
        operational: %{
          timing: %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
        }
      }

      expected =
        {:ok,
         "{\"_metadata\":[],\"dataset_id\":\"abc\",\"operational\":" <>
           "{\"timing\":{\"app\":\"reaper\",\"end_time\":10," <>
           "\"label\":\"sus\",\"start_time\":5}},\"payload\":\"whatever\"}"}

      assert DataMessage.encode(data_message) == expected
    end
  end

  describe "add_timing" do
    test "throws error with invalid timing" do
      invalid_timing = Timing.new(app: "whatever", label: "whatever")

      message =
        DataMessage.new(
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        )

      assert_raise ArgumentError, fn -> DataMessage.add_timing(message, invalid_timing) end
    end

    test "adds valid timing" do
      valid_timing =
        Timing.new(
          app: "whatever",
          label: "whatever",
          start_time: Timing.current_time(),
          end_time: Timing.current_time()
        )

      message =
        DataMessage.new(
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        )

      assert %DataMessage{operational: %{timing: [^valid_timing]}} = DataMessage.add_timing(message, valid_timing)
    end
  end

  describe "get_all_timings" do
    test "returns timings" do
      timing =
        Timing.new(
          app: "whatever",
          label: "whatever",
          start_time: Timing.current_time(),
          end_time: Timing.current_time()
        )

      message =
        DataMessage.new(
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: [timing]}
        )

      assert [^timing] = DataMessage.get_all_timings(message)
    end
  end
end
