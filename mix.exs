defmodule Congress.MixProject do
  use Mix.Project

  @source_url "https://github.com/joshrotenberg/congress_ex"

  def project do
    [
      app: :congress,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Josh Rotenberg"],
      licenses: ["Apache"],
      links: %{"GitHub" => @source_url}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3.8"},
      {:jason, "~> 1.4"},
      {:recase, "~> 0.7.0"},

      # dev
      {:credo, "~> 1.7", only: [:dev], runtime: false},
      {:doctor, "~> 0.21.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.29.4", only: [:dev], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev], runtime: false},

      # test
      {:exvcr, "~> 0.11", only: :test},
      {:excoveralls, "~> 0.16", only: :test},
      {:dialyxir, "~> 1.3", only: :test, runtime: false}
    ]
  end
end
