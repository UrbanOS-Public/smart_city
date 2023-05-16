import Config

config :plug, :mimes, %{
  "application/gtfs+protobuf" => ["gtfs"],
  "application/vnd.ogc.wms_xml" => ["wms"]
}
