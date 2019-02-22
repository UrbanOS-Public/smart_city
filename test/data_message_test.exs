defmodule SCOS.DataMessageTest do
  use ExUnit.Case
  doctest SCOS.DataMessage

  alias SCOS.DataMessage

  test "put operational works when app and key don't already exist" do
    message = struct!(DataMessage)

    new_message = DataMessage.put_operational(message, :valkyrie, :test_val, 75)

    assert ^new_message = %DataMessage{operational: %{valkyrie: %{test_val: 75}}}
  end

  test "put_operational does not overwrite app when it does exist" do
    message = struct!(DataMessage, %{operational: %{valkyrie: %{keep: :me}}})

    new_message = DataMessage.put_operational(message, :valkyrie, :val_test, 85)

    assert ^new_message = %DataMessage{operational: %{valkyrie: %{val_test: 85, keep: :me}}}
  end
end
