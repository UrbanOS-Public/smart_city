defmodule SCOS.MixProject do
  use Mix.Project

  def project do
    [
      app: :scos_ex,
      version: "1.3.0",
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
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:placebo, "~> 1.2", only: :test},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A library for shared Elixir modules in the Columbus SCOS project."
  end

  defp package do
    [
      organization: "smartcolumbus_os",
      licenses: ["AllRightsReserved"],
      links: %{"GitHub" => "https://www.github.com/SmartColumbusOS/scos_ex"}
    ]
  end
end
