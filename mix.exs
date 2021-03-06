defmodule Logi.Mixfile do
  use Mix.Project

  def project do
    [app: :logi_ex,
     version: "0.1.1",
     elixir: "~> 1.2",
     description: "A logger interface library",
     package: [
       maintainers: ["Takeru Ohta"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/sile/logi_ex"}
     ],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logi]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:logi, "~> 0.5"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end
end
