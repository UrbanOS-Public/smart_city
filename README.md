# SCOS

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `scos_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scos_ex, "~> 0.1.0", organization: "smartcolumbus_os"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://smartcolumbus_os.hexdocs.pm/scos_ex](https://smartcolumbus_os.hexdocs.pm/scos_ex/api-reference.html).

## Contributing

Make your changes and run `docker build .`. This is exactly what our CI will do. The build process runs these commands:

```bash
mix deps.get
mix test
mix format --check-formatted
mix credo
```
