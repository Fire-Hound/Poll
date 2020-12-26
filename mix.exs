defmodule Poll.MixProject do
  use Mix.Project

  def project do
    [
      app: :poll,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A poll bot written in nostrum for discord",
      package: package(),
      source_url: "https://github.com/Fire-Hound/Poll"
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
      {:nostrum, "~> 0.4"},
      {:gnuplot, "~> 1.20"},
      {:ex_doc, "~> 0.23", runtime: false}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
  defp package do
    [
      links: %{"GitHub" => "https://github.com/Fire-Hound/Poll"},
      licenses: ["MIT"],
      files: ~w(lib config .formatter.exs mix.exs README* readme* LICENSE*)
    ]
  end
end
