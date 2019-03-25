# SmartCity.Data

#### DataMessage

```javascript
const DataMessage = {
    "dataset_id": "",         // UUID
    "payload": {},
    "_metadata": {           // cannot be used safely
        "orgName": "",       // ~r/^[a-zA-Z_]+$/
        "dataName": "",      // ~r/^[a-zA-Z_]+$/
        "stream": true
    },
    "operational": {
        "timing": [{
            "startTime": "", // iso8601
            "endTime": "",   // iso8601
            "app": "",       // microservice generating timing data
            "label": ""      // label for this particular timing data
        }]
    },
}
```

## Installation

This package is [available in Hex](https://hex.pm/docs/publish) under the `smartcolumbus_os` organization, the package can be installed
by adding `smart_city_data` to your list of dependencies in `mix.exs` as follows:

```elixir
def deps do
  [
    {:smart_city_data, "~> 2.0.1", organization: "smartcolumbus_os"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://smartcolumbus_os.hexdocs.pm/smart_city_data](https://smartcolumbus_os.hexdocs.pm/scos_ex/api-reference.html).

## Contributing

Make your changes and run `docker build .`. This is exactly what our CI will do. The build process runs these commands:

```bash
mix deps.get
mix test
mix format --check-formatted
mix credo
```
