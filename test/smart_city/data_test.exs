defmodule SmartCity.DataTest do
  use ExUnit.Case
  use Placebo
  doctest SmartCity.Data

  alias SmartCity.Data
  alias SmartCity.Data.Timing

  describe "new" do
    test "turns a map with string keys into a Data" do
      map = %{
        "dataset_id" => "abc",
        "payload" => "whatever",
        "ingestion_id" => "get-that-data-0000",
        "extraction_start_time" => "2022-05-13T13:48:06+00:00",
        "_metadata" => %{org: "whatever", name: "stuff", stream: true},
        "operational" => %{"timing" => [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      {:ok, actual} = Data.new(map)

      assert actual.dataset_id == "abc"
      assert actual.payload == "whatever"
      assert actual._metadata == %{org: "whatever", name: "stuff", stream: true}
      assert actual.operational.timing == [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
      assert actual.ingestion_id == "get-that-data-0000"
      assert actual.extraction_start_time == "2022-05-13T13:48:06+00:00"
    end

    test "turns a map with atom keys into a Data" do
      map = %{
        dataset_id: "abc",
        payload: "whatever",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        _metadata: %{org: "whatever", name: "stuff", stream: true},
        operational: %{timing: [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      {:ok, actual} = Data.new(map)

      assert actual == %Data{
               dataset_id: "abc",
               payload: "whatever",
               ingestion_id: "get-that-data-0000",
               extraction_start_time: "2022-05-13T13:48:06+00:00",
               _metadata: %{org: "whatever", name: "stuff", stream: true},
               operational: %{timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
             }
    end

    test "returns error tuple when creating Data without required fields" do
      {:error, reason} = Data.new(%{dataset_id: "", operational: ""})
      assert Regex.match?(~r/Invalid data message:/, reason)
    end

    test "converts a JSON message into a Data" do
      map = %Data{
        dataset_id: "abc",
        payload: "whatever",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        _metadata: %{org: "whatever", name: "stuff", stream: true},
        operational: %{timing: [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
      }

      json = Jason.encode!(map)

      assert Data.new(json) == Data.new(map)
    end

    test "converts a JSON message into data but preserving payload keys as strings" do
      json =
        %{
          dataset_id: "ds1",
          payload: %{"name" => "johnny", "age" => "21"},
          _metadata: %{},
          operational: %{timing: [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]}
        }
        |> Jason.encode!()

      {:ok, data} = SmartCity.Data.new(json)

      assert data.payload == %{"name" => "johnny", "age" => "21"}
    end

    test "keeps all operational data" do
      map = %{
        "dataset_id" => "abc",
        "payload" => "whatever",
        "_metadata" => %{org: "whatever", name: "stuff", stream: true},
        "operational" => %{
          "anything_else" => ["one", "two", "three"],
          "timing" => [%{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
        }
      }

      {:ok, actual} = Data.new(map)

      expected = %{
        timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}],
        anything_else: ["one", "two", "three"]
      }

      assert expected == actual.operational
    end
  end

  describe "encode" do
    test "encodes to JSON" do
      data_message = %Data{
        dataset_id: "abc",
        payload: "whatever",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        _metadata: [],
        operational: %{
          timing: %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
        }
      }

      expected =
        {:ok,
         ~s({"_metadata":[],"dataset_id":"abc","extraction_start_time":"2022-05-13T13:48:06+00:00","ingestion_id":"get-that-data-0000","operational":{"timing":{"app":"reaper","end_time":10,"label":"sus","start_time":5}},"payload":"whatever","version":"0.1"})}

      assert Data.encode(data_message) == expected
    end
  end

  describe "encode!" do
    test "encodes to JSON" do
      data_message = %Data{
        dataset_id: "abc",
        payload: "whatever",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        _metadata: [],
        operational: %{
          timing: %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
        }
      }

      expected =
        ~s({"_metadata":[],"dataset_id":"abc","extraction_start_time":"2022-05-13T13:48:06+00:00","ingestion_id":"get-that-data-0000","operational":{"timing":{"app":"reaper","end_time":10,"label":"sus","start_time":5}},"payload":"whatever","version":"0.1"})

      assert Data.encode!(data_message) == expected
    end

    test "raises Jason.EncodeError if message can't be encoded" do
      data_message = %Data{
        dataset_id: "\xFF",
        payload: "whatever",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: "whatever",
        _metadata: [],
        operational: %{
          timing: %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
        }
      }

      assert_raise Jason.EncodeError, fn ->
        Data.encode!(data_message)
      end
    end
  end

  describe "timed_new" do
    test "news message on success" do
      app = "scos_ex"
      label = "&SmartCity.Data.new/1"
      timing = %Timing{app: app, label: label, start_time: 0, end_time: 5}

      initial_message = %Data{
        dataset_id: :guid,
        payload: :initial,
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        _metadata: [],
        operational: %{
          timing: [
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
          ]
        }
      }

      json_message = Data.encode!(initial_message)

      expected_message = %Data{
        dataset_id: "guid",
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: "initial",
        _metadata: [],
        operational: %{
          timing: [
            timing,
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
          ]
        }
      }

      allow(Data.Timing.measure(app, label, any()),
        exec: fn _a, _l, f ->
          {:ok, result} = f.()
          {:ok, result, timing}
        end,
        meck_options: [:passthrough]
      )

      assert Data.timed_new(json_message, app) == {:ok, expected_message}
    end

    test "returns error tuple on failure" do
      app = "scos_ex"
      label = "&SmartCity.Data.new/1"

      initial_message = %Data{
        dataset_id: :guid,
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
          ]
        }
      }

      json_message = Data.encode!(initial_message)

      allow(Data.Timing.measure(app, label, any()), return: {:error, :reason}, meck_options: [:passthrough])

      assert Data.timed_new(json_message, app) == {:error, :reason}
    end
  end

  describe "timed_transform" do
    test "passes through message with updated payload and timing on success" do
      app = "scos_ex"
      label = "&Fake.do_thing/1"

      data_message = %Data{
        dataset_id: :guid,
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
        }
      }

      timing = %Timing{app: app, label: label, start_time: 0, end_time: 5}

      expected_message = %Data{
        dataset_id: :guid,
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: :whatever,
        _metadata: [],
        operational: %{
          timing: [
            timing,
            %Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}
          ]
        }
      }

      allow(Fake.do_thing(data_message.payload), return: {:ok, :whatever}, meck_options: [:non_strict])

      allow(Data.Timing.measure(app, label, any()),
        return: {:ok, :whatever, timing},
        meck_options: [:passthrough]
      )

      assert Data.timed_transform(data_message, app, &Fake.do_thing/1) == {:ok, expected_message}
    end

    test "returns error tuple on failure" do
      data_message = %Data{
        dataset_id: :guid,
        ingestion_id: "get-that-data-0000",
        extraction_start_time: "2022-05-13T13:48:06+00:00",
        payload: :initial,
        _metadata: [],
        operational: %{
          timing: [%Timing{app: "reaper", label: "sus", start_time: 5, end_time: 10}]
        }
      }

      app = "scos_ex"
      label = "&Fake.do_thing/1"

      allow(Fake.do_thing(data_message.payload), return: {:error, :reason}, meck_options: [:non_strict])
      allow(Data.Timing.measure(app, label, any()), return: {:error, :reason}, meck_options: [:passthrough])

      assert Data.timed_transform(data_message, app, &Fake.do_thing/1) == {:error, :reason}
    end
  end

  describe "add_timing" do
    test "throws error with invalid timing" do
      invalid_timing = Timing.new(app: "whatever", label: "whatever")

      {:ok, message} =
        Data.new(%{
          dataset_id: "whatever",
          ingestion_id: "whatever",
          extraction_start_time: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        })

      assert_raise ArgumentError, fn -> Data.add_timing(message, invalid_timing) end
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
        Data.new(%{
          dataset_id: "whatever",
          ingestion_id: "whatever",
          extraction_start_time: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: []}
        })

      assert %Data{operational: %{timing: [^valid_timing]}} = Data.add_timing(message, valid_timing)
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
        Data.new(%{
          dataset_id: "whatever",
          ingestion_id: "whatever",
          extraction_start_time: "whatever",
          payload: "whatever",
          _metadata: "whatever",
          operational: %{timing: [timing]}
        })

      assert [^real_timing] = Data.get_all_timings(message)
    end
  end
end
