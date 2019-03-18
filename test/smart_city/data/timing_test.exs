defmodule SmartCity.Data.TimingTest do
  use ExUnit.Case
  use Placebo

  alias SmartCity.Data.Timing

  describe "new" do
    test "throws error without required keys" do
      assert_raise ArgumentError, fn -> Timing.new(%{}) end
    end

    test "creates a Timing struct with required keys" do
      assert Timing.new(%{app: "foo", label: "bar"}) == %Timing{app: "foo", label: "bar"}
    end

    test "new/4 creates a Timing struct with all keys" do
      assert Timing.new("foo", "bar", "not_validated", "not_validated") == %Timing{
               app: "foo",
               label: "bar",
               start_time: "not_validated",
               end_time: "not_validated"
             }
    end
  end

  describe "validate" do
    test "validates all 4 fields are present" do
      app = "AppName"
      label = "MetricName"
      start_time = Timing.current_time()
      end_time = Timing.current_time()

      timing = %Timing{
        app: app,
        label: label,
        start_time: start_time,
        end_time: end_time
      }

      assert {:ok, %Timing{app: ^app, label: ^label, start_time: ^start_time, end_time: ^end_time}} =
               Timing.validate(timing)
    end

    test "throws an error when keys are missing" do
      app = "AppName"
      label = "MetricName"

      timing = %Timing{
        app: app,
        label: label
      }

      assert {:error, _} = Timing.validate(timing)
    end
  end

  describe "measure" do
    test "wraps the result of a function/0 in timing information" do
      start_time = DateTime.from_naive(~N[2019-01-01 00:00:00.000], "UTC")
      end_time = DateTime.from_naive(~N[2019-01-02 00:00:00.000], "UTC")

      allow(DateTime.utc_now(), seq: [start_time, end_time])
      allow(Fake.do_thing(), return: {:ok, :whatever}, meck_options: [:non_strict])

      assert Timing.measure("app", "label", &Fake.do_thing/0) ==
               {:ok, :whatever,
                %Timing{
                  app: "app",
                  label: "label",
                  start_time: start_time,
                  end_time: end_time
                }}
    end

    test "properly handles errors in tuple form" do
      start_time = DateTime.from_naive(~N[2019-01-01 00:00:00.000], "UTC")
      end_time = DateTime.from_naive(~N[2019-01-02 00:00:00.000], "UTC")

      allow(DateTime.utc_now(), seq: [start_time, end_time])
      allow(Fake.do_thing(), return: {:error, :reason}, meck_options: [:non_strict])

      assert Timing.measure("app", "label", &Fake.do_thing/0) == {:error, :reason}
    end

    test "properly handles things that don't return tuples" do
      start_time = DateTime.from_naive(~N[2019-01-01 00:00:00.000], "UTC")
      end_time = DateTime.from_naive(~N[2019-01-02 00:00:00.000], "UTC")

      allow(DateTime.utc_now(), seq: [start_time, end_time])
      allow(Fake.do_thing(), return: :non_conforming, meck_options: [:non_strict])

      assert Timing.measure("app", "label", &Fake.do_thing/0) == {:error, :non_conforming}
    end
  end

  describe "validate!" do
    test "validates all 4 fields are present" do
      app = "AppName"
      label = "MetricName"
      start_time = Timing.current_time()
      end_time = Timing.current_time()

      timing = %Timing{
        app: app,
        label: label,
        start_time: start_time,
        end_time: end_time
      }

      assert %Timing{app: ^app, label: ^label, start_time: ^start_time, end_time: ^end_time} = Timing.validate!(timing)
    end

    test "throws an error when keys are missing" do
      app = "AppName"
      label = "MetricName"

      timing = %Timing{
        app: app,
        label: label
      }

      assert_raise ArgumentError, fn -> Timing.validate!(timing) end
    end
  end
end
