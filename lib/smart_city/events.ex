defmodule SmartCity.Events do
  @moduledoc """
  Defines macros for encoding event types the Smart City platform
  will respond to in any of the various micro service components
  in a central location shared by all components.
  """

  @doc """
  Defines an update event to a dataset within the system. The
  system treats create events as a subset of updates.
  """
  defmacro update_dataset(), do: "dataset:update"

  @doc """
  Defines an update event to an organization within the system.
  The system treats create events as a subset of updates.
  """
  defmacro update_organization(), do: "organization:update"

  @doc """
  Signals that a new file has been uploaded to the object store
  and made available for the rest of the system.
  """
  defmacro file_uploaded(), do: "file:uploaded"
end
