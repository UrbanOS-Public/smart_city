defmodule SmartCity.Data.MixProject do
  use Mix.Project

  def project do
    [
      app: :smart_city_data,
      version: "2.1.7",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: "https//www.github.com/smartcitiesdata"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev]},
      {:ex_doc, "~> 0.19", only: :dev},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:placebo, "~> 1.2", only: :test},
      {:smart_city, "~> 2.1"},
      {:husky, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A library for Smart City Data"
  end

  defp package do
    [
      maintainers: ["smartcitiesdata"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://www.github.com/smartcitiesdata/smart_city_data"}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: "https://github.com/smartcitiesdata/smart_city_data",
      extras: [
        "README.md"
      ]
    ]
  end
end
