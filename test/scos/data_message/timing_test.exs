defmodule SCOS.DataMessage.TimingTest do
  use ExUnit.Case
  alias SCOS.DataMessage.Timing

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
