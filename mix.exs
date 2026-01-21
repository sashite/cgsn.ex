defmodule Sashite.Cgsn.MixProject do
  use Mix.Project

  @version "1.1.0"
  @source_url "https://github.com/sashite/cgsn.ex"

  def project do
    [
      app: :sashite_cgsn,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Sashite.Cgsn",
      source_url: @source_url,
      homepage_url: "https://sashite.dev/specs/cgsn/",
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    CGSN (Chess Game Status Notation) implementation for Elixir.
    Provides a rule-agnostic taxonomy of observable game status values for abstract strategy board games.
    """
  end

  defp package do
    [
      name: "sashite_cgsn",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Specification" => "https://sashite.dev/specs/cgsn/1.0.0/",
        "Documentation" => "https://hexdocs.pm/sashite_cgsn"
      },
      maintainers: ["Cyril Kato"]
    ]
  end
end
