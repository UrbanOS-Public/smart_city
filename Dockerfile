FROM hexpm/elixir:1.14.4-erlang-25.3.2
COPY . /app
WORKDIR /app
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix test \
    && mix format --check-formatted \
    && mix credo
