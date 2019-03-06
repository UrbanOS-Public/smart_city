defmodule SCOS.DataMessageTest do
  use ExUnit.Case
  doctest SCOS.DataMessage

  alias SCOS.DataMessage
  alias SCOS.DataMessage.Timing

  describe "new" do
    test "turns a map with string keys into a DataMessage" do
      map = %{
        "dataset_id" => "abc",
        "payload" => "whatever",
        "_metadata" => %{org: "whatever", name: "stuff", stream: true},
        "operational" => %{"timing" => [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      {:ok, actual} = DataMessage.new(map)

      assert actual.dataset_id == "abc"
      assert actual.payload == "whatever"
      assert actual._metadata == %{org: "whatever", name: "stuff", stream: true}
      assert actual.operational.timing == [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
    end

    test "turns a map with atom keys into a DataMessage" do
      map = %{
        dataset_id: "abc",
        payload: "whatever",
        _metadata: %{org: "whatever", name: "stuff", stream: true},
        operational: %{timing: [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      {:ok, actual} = DataMessage.new(map)

      assert actual == %DataMessage{
               dataset_id: "abc",
               payload: "whatever",
               _metadata: %{org: "whatever", name: "stuff", stream: true},
               operational: %{timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
             }
    end

    test "returns error tuple when creating DataMessage without required fields" do
      {:error, reason} = DataMessage.new(%{dataset_id: "", operational: ""})
      assert Regex.match?(~r/Invalid data message:/, reason)
    end

    test "converts a JSON message into a DataMessage" do
      map = %DataMessage{
        dataset_id: "abc",
        payload: "whatever",
        _metadata: %{org: "whatever", name: "stuff", stream: true},
        operational: %{timing: [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      json = Jason.encode!(map)

      assert DataMessage.new(json) == DataMessage.new(map)
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
         ~s({"_metadata":[],"dataset_id":"abc","operational":{"timing":{"app":"reaper","end_time":10,"label":"sus","start_time":5}},"payload":"whatever"})}

      assert DataMessage.encode(data_message) == expected
    end
  end

  describe "encode!" do
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
        ~s({"_metadata":[],"dataset_id":"abc","operational":{"timing":{"app":"reaper","end_time":10,"label":"sus","start_time":5}},"payload":"whatever"})

      assert DataMessage.encode!(data_message) == expected
    end

    test "raises Jason.EncodeError if message can't be encoded" do
      data_message = %DataMessage{
        dataset_id: "\xFF",
        payload: "whatever",
        _metadata: [],
        operational: %{
          timing: %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
        }
      }

      assert_raise Jason.EncodeError, fn ->
        DataMessage.encode!(data_message)
      end
    end
  end

  describe "add_timing" do
    test "throws error with invalid timing" do
      invalid_timing = Timing.new(app: "whatever", label: "whatever")

      {:ok, message} =
        DataMessage.new(%{
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        })

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

      {:ok, message} =
        DataMessage.new(%{
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        })

      assert %DataMessage{operational: %{timing: [^valid_timing]}} = DataMessage.add_timing(message, valid_timing)
    end
  end

  describe "get_all_timings" do
    test "returns timings" do
      timing = %{
        app: "whatever",
        label: "whatever",
        start_time: Timing.current_time(),
        end_time: Timing.current_time()
      }

      real_timing = Timing.new(timing)

      {:ok, message} =
        DataMessage.new(%{
          dataset_id: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: [timing]}
        })

      assert [^real_timing] = DataMessage.get_all_timings(message)
    end
  end
end
