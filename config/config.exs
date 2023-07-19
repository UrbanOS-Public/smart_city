import Config

config :mime, :types, %{
  "application/gtfs+protobuf" => ["gtfs"],
  "application/vnd.ogc.wms_xml" => ["wms"]
}
