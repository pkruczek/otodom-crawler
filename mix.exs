defmodule Scraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :scraper,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Scraper.Application, []}
    ]
  end

  defp deps do
    [
      {:crawly, "~> 0.13.0"},
      {:floki, "~> 0.26.0"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, "~> 0.16.2"},
      {:jason, "~> 1.3"}
    ]
  end
end
