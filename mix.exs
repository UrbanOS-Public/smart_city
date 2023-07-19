defmodule SmartCity.MixProject do
  use Mix.Project

  def project do
    [
      app: :smart_city,
      version: "6.0.0",
      elixir: "~> 1.14.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: "https://www.github.com/smartcitiesdata/smart_city"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:accessible, "~> 0.3"},
      {:brook_serializer, "~> 2.2"},
      {:checkov, "~> 1.0", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev]},
      {:ex_doc, "~> 0.29", only: :dev},
      {:jason, "~> 1.4"},
      {:mime, "~> 2.0"},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:placebo, "~> 2.0", only: [:dev, :test, :integration]},
      {:timex, "~> 3.7"}
    ]
  end

  defp description do
    "A library for shared helper modules in the Smart Cities Data project."
  end

  defp package do
    [
      maintainers: ["smartcitiesdata"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://www.github.com/smartcitiesdata/smart_city"}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: "https://github.com/smartcitiesdata/smart_city",
      extras: [
        "README.md"
      ]
    ]
  end
end
