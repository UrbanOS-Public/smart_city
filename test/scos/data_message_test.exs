defmodule SCOS.DataMessageTest do
  use ExUnit.Case
  use Placebo
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

  describe "timed_new" do
    test "news message on success" do
      app = "scos_ex"
      label = "&SCOS.DataMessage.new/1"
      timing = %Timing{app: app, label: label, start_time: 0, end_time: 5}
      initial_message = %DataMessage{
        dataset_id: :guid,
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10},
          ]
        }
      }
      json_message = DataMessage.encode!(initial_message)

      expected_message = %DataMessage{
        dataset_id: "guid",
        payload: "initial",
        _metadata: [],
        operational: %{
          timing: [
            timing,
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10},
          ]
        }
      }

      allow DataMessage.Timing.measure(app, label, any()), exec: fn _a, _l, f ->
        {:ok, result} = f.()
        {:ok, result, timing}
      end, meck_options: [:passthrough]

      assert DataMessage.timed_new(json_message, app) == {:ok, expected_message}
    end

    test "returns error tuple on failure" do
      app = "scos_ex"
      label = "&SCOS.DataMessage.new/1"
      initial_message = %DataMessage{
        dataset_id: :guid,
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10},
          ]
        }
      }
      json_message = DataMessage.encode!(initial_message)

      allow DataMessage.Timing.measure(app, label, any()), return: {:error, :reason}, meck_options: [:passthrough]

      assert DataMessage.timed_new(json_message, app) == {:error, :reason}
    end
  end

  describe "timed_transform" do
    test "passes through message with updated payload and timing on success" do
      app = "scos_ex"
      label = "&Fake.do_thing/1"
      data_message = %DataMessage{
        dataset_id: :guid,
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
        }
      }
      timing = %Timing{app: app, label: label, start_time: 0, end_time: 5}
      expected_message = %DataMessage{
        dataset_id: :guid,
        payload: :whatever,
        _metadata: [],
        operational: %{
          timing: [
            timing,
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10},
          ]
        }
      }

      allow Fake.do_thing(data_message.payload), return: {:ok, :whatever}, meck_options: [:non_strict]
      allow DataMessage.Timing.measure(app, label, any()), return: {:ok, :whatever, timing}, meck_options: [:passthrough]

      assert DataMessage.timed_transform(data_message, app, &Fake.do_thing/1) == {:ok, expected_message}
    end

    test "returns error tuple on failure" do
      data_message = %DataMessage{
        dataset_id: :guid,
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
        }
      }
      app = "scos_ex"
      label = "&Fake.do_thing/1"

      allow Fake.do_thing(data_message.payload), return: {:error, :reason}, meck_options: [:non_strict]
      allow DataMessage.Timing.measure(app, label, any()), return: {:error, :reason}, meck_options: [:passthrough]

      assert DataMessage.timed_transform(data_message, app, &Fake.do_thing/1) == {:error, :reason}
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
