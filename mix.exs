defmodule SmartCity.MixProject do
  use Mix.Project

  def project do
    [
      app: :smart_city,
      version: "2.2.0",
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
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev]},
      {:ex_doc, "~> 0.21", only: :dev},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:husky, "~> 1.0", only: :dev, runtime: false}
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
