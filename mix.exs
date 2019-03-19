defmodule SmartCity.MixProject do
  use Mix.Project

  def project do
    [
      app: :smart_city,
      version: "2.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https//www.github.com/SmartColumbusOS"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A library for shared helper modules in the Columbus SCOS project."
  end

  defp package do
    [
      organization: "smartcolumbus_os",
      licenses: ["AllRightsReserved"],
      links: %{"GitHub" => "https://www.github.com/SmartColumbusOS/smart_city"}
    ]
  end
end
