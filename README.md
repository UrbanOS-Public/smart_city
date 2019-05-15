[![Master](https://travis-ci.org/smartcitiesdata/smart_city.svg?branch=master)](https://travis-ci.org/smartcitiesdata/smart_city)
[![Hex.pm Version](http://img.shields.io/hexpm/v/smart_city.svg?style=flat)](https://hex.pm/packages/smart_city)

# SmartCity

This library defines helper functions that are used across SmartCity modules.

## Installation

```elixir
def deps do
  [
    {:smart_city, "~> 2.1.3"}
  ]
end
```

## Basic Usage

```elixir
iex> SmartCity.Helpers.to_atom_keys(%{"a" => 1, "b" => 2, "c" => 3})
%{a: 1, b: 2, c: 3}

iex> SmartCity.Helpers.to_atom_keys(%{"a" => %{"b" => "c"}})
%{a: %{b: "c"}}

iex> SmartCity.Helpers.deep_merge(%{a: 1, b: 2}, %{a: 3, c: 4})
%{a: 3, b: 2, c: 4}
```

Full documentation can be found at [https://hexdocs.pm/smart_city/api-reference.html](https://hexdocs.pm/smart_city/api-reference.html).

## Contributing

The build process runs these commands:

```bash
mix local.rebar --force
mix local.hex --force
mix deps.get
mix format --check-formatted
mix credo
mix test
```

## License

SmartCity is released under the Apache 2.0 license - see the license at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
