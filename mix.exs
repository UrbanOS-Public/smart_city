defmodule SmartCity.MixProject do
  use Mix.Project

  def project do
    [
      app: :smart_city,
      version: "2.9.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: "https//www.github.com/smartcitiesdata/smart_city"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:brook_serializer, github: "bbalser/brook_serializer", branch: "master"},
      {:checkov, "~> 0.4", only: :test},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev]},
      {:ex_doc, "~> 0.21", only: :dev},
      {:husky, "~> 1.0", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:mime, "~> 1.3"},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:placebo, "~> 1.2", only: [:dev, :test, :integration]}
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
