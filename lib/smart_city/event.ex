defmodule SmartCity.Event do
  @moduledoc """
  Defines macros for encoding event types the Smart City platform
  will respond to in any of the various micro service components
  in a central location shared by all components.
  """

  @doc """
  Defines an update event to a dataset within the system. The
  system treats create events as a subset of updates.
  """
  defmacro dataset_update(), do: quote(do: "dataset:update")

  @doc """
  Declares an error occurred during the attempted upsert of a
  dataset.
  """
  defmacro error_dataset_update(), do: quote(do: "error:dataset:update")

  @doc """
  Defines an update event to an organization within the system.
  The system treats create events as a subset of updates.
  """
  defmacro organization_update(), do: quote(do: "organization:update")

  @doc """
  Declares an error occurred during the attempted upsert of an
  organization.
  """
  defmacro error_organization_update(), do: quote(do: "error:organization:update")

  @doc """
  Signals a dataset is about to be retrieved and begin loading into
  the ingestion pipeline.
  """
  defmacro data_ingest_start(), do: quote(do: "data:ingest:start")

  @doc """
  Signals a dataset has completed an ingestion process through the
  pipeline from end to end and been persisted.
  """
  defmacro data_ingest_end(), do: quote(do: "data:ingest:end")

  @doc """
  Declares an error occurred during an attempted data ingestion.
  """
  defmacro error_data_ingest(), do: quote(do: "error:data:ingest")

  @doc """
  Signals data for a dataset is about to be downloaded into the platform,
  parsed, and written to the raw ingestion topic.
  """
  defmacro data_extract_start(), do: quote(do: "data:extract:start")

  @doc """
  Signals a dataset has completed the extraction process and the final
  message has been written to the raw ingestion topic.
  """
  defmacro data_extract_end(), do: quote(do: "data:extract:end")

  @doc """
  Declares an error occurred during an attempted data extraction.
  """
  defmacro error_data_extract(), do: quote(do: "error:data:extract")

  @doc """
  Signals a non-ingestable data file is about to be downloaded to the
  platform and stored in the object store bucket.
  """
  defmacro file_ingest_start(), do: quote(do: "file:ingest:start")

  @doc """
  Signals a non-ingestable data file has been successfully uploaded
  to the object store bucket.
  """
  defmacro file_ingest_end(), do: quote(do: "file:ingest:end")

  @doc """
  Declares an error occurred during an attempted file ingestion.
  """
  defmacro error_file_ingest(), do: quote(do: "error:file:ingest")

  @doc """
  Signals that a dataset should be disabled.
  """
  defmacro dataset_disable(), do: quote(do: "dataset:disable")

  @doc """
  Signals that a dataset should be deleted
  """
  defmacro dataset_delete(), do: quote(do: "dataset:delete")

  @doc """
  Signals that writing some data for a dataset has completed
  """
  defmacro data_write_complete(), do: quote(do: "data:write:complete")

  @doc """
  Signals that data standardization is complete
  """
  defmacro data_standardization_end(), do: quote(do: "data:standardization:end")

  @doc """
  Signals that a table has been created. Used for EventLogs.
  """
  defmacro table_created(), do: quote(do: "table:created")

  @doc """
  Signals that data has been retrieved and placed on the topic. Used for EventLogs.
  """
  defmacro data_retrieved(), do: quote(do: "data:retrieved")

  @doc """
  Defines a user organization relationship.
  """
  defmacro user_organization_associate(), do: quote(do: "user:organization:associate")

  @doc """
  Defines a user organization relationship.
  """
  defmacro user_organization_disassociate(), do: quote(do: "user:organization:disassociate")

  @doc """
  Defines a user access group relationship.
  """
  defmacro user_access_group_associate(), do: quote(do: "user:access_group:associate")

  @doc """
  Defines a user access group relationship.
  """
  defmacro user_access_group_disassociate(), do: quote(do: "user:access_group:disassociate")

  @doc """
  Defines a dataset access group relationship.
  """
  defmacro dataset_access_group_associate(), do: quote(do: "dataset:access_group:associate")

  @doc """
  Defines a dataset access group relationship.
  """
  defmacro dataset_access_group_disassociate(), do: quote(do: "dataset:access_group:disassociate")

  @doc """
  Signals a dataset harvest start
  """
  defmacro dataset_harvest_start(), do: quote(do: "dataset:harvest:start")

  @doc """
  Signals a dataset harvest end
  """
  defmacro dataset_harvest_end(), do: quote(do: "dataset:harvest:end")

  @doc """
  Signals a dataset query has been run
  """
  defmacro dataset_query(), do: quote(do: "dataset:query")

  @doc """
  Signals a user has logged in
  """
  defmacro user_login(), do: quote(do: "user:login")

  @doc """
  Signals an ingestion update has occurred
  """
  defmacro ingestion_update(), do: quote(do: "ingestion:update")

  @doc """
  Declares an error occurred during the attempted update of an ingestion.
  """
  defmacro error_ingestion_update(), do: quote(do: "error:ingestion:update")

  @doc """
  Signals an ingestion should be deleted
  """
  defmacro ingestion_delete(), do: quote(do: "ingestion:delete")

  @doc """
  Signals to file should be downloaded
  """
  @deprecated "Use file_ingest_start/0"
  defmacro hosted_file_start(), do: quote(do: "hosted:file:start")

  @doc """
  Hosted file and been downloaded and stored
  """
  @deprecated "Use file_ingest_end/0"
  defmacro hosted_file_complete(), do: quote(do: "hosted:file:complete")

  @doc """
  Signals that a new file has been uploaded to the object store
  and made available for the rest of the system.
  """
  @deprecated "Use file_ingest_end/0"
  defmacro file_upload(), do: quote(do: "file:upload")

  @doc """
  Signals that a dataset extraction is starting
  """
  @deprecated "Use data_extract_start/0"
  defmacro dataset_extract_start(), do: quote(do: "dataset:extract:start")

  @doc """
  Signals that dataset extraction has completed
  """
  @deprecated "Use data_extract_end/0"
  defmacro dataset_extract_complete(), do: quote(do: "dataset:extract:complete")
end
