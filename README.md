# SmartCity.Data

This module defines the structure of data messages that are sent across all SmartCity microservices. The `SmartCity.Data` struct includes metadata and timing information about the process from which the message was generated.  

Timing information is defined by the `SmartCity.Data.Timing` struct.   

For more details about the structure of data messages, see [https://smartcolumbus_os.hexdocs.pm/smart_city_data/api-reference.html](https://smartcolumbus_os.hexdocs.pm/smart_city_data/2.1.3/api-reference.html). 

## Basic Usage
```elixir
iex> SmartCity.Data.new(%{dataset_id: "a_guid", payload: "the_data", _metadata: %{org: "scos", name: "example"}, operational: %{timing: [%{app: "app name", label: "function name", start_time: "2019-05-06T19:51:41+00:00", end_time: "2019-05-06T19:51:51+00:00"}]}})
{:ok, %SmartCity.Data{
    dataset_id: "a_guid",
    payload: "the_data",
    _metadata: %{org: "scos", name: "example"},
    operational: %{
        timing: [%SmartCity.Data.Timing{ 
            app: "app name",
            end_time: "2019-05-06T19:51:51+00:00", 
            label: "function name", 
            start_time: "2019-05-06T19:51:41+00:00"
        }]
    }
}}
```

## Installation

```elixir
def deps do
  [
    {:smart_city_data, "~> 2.1.3", organization: "smartcolumbus_os"}
  ]
end
```

## Contributing

Make your changes and run `docker build .`. This is exactly what our CI will do. The build process runs these commands:

```bash
mix deps.get
mix test
mix format --check-formatted
mix credo
```

## License

SmartCity is released under the Apache 2.0 license - see the license at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
