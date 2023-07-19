[![Master](https://travis-ci.org/smartcitiesdata/smart_city.svg?branch=master)](https://travis-ci.org/smartcitiesdata/smart_city)
[![Hex.pm Version](http://img.shields.io/hexpm/v/smart_city.svg?style=flat)](https://hex.pm/packages/smart_city)

# SmartCity

This library defines helper functions that are used across SmartCity modules.

## Installation

```elixir
def deps do
  [
    {:smart_city, "~> 3.20.1"}
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

## Releases

New versions are [published here](https://hexdocs.pm/smart_city/readme.html) whenever a Github release is cut. 
The version # of `smart_city` is expected to sync with [`smart_city_test`](https://github.com/UrbanOS-Public/smart_city_test). 
When cutting a release in either package, the other should also receive an update so that it utilizes the new package version.

Ex: After updating the `smart_city` version by changing the version in `mix.exs`, merging, and cutting a release, `smart_city_test` should receive an 
update PR as well. That `smart_city_test` PR should update the version of `smart_city` in the `mix.exs` file, and a release of `smart_city_test` should 
be made.

It's expected that the version of `smart_city` and `smart_city_test` always match in their `mix.exs` file and their github releases.

## License

SmartCity is released under the Apache 2.0 license - see the license at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
