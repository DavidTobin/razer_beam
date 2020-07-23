defmodule RazerBeam.MixProject do
  use Mix.Project

  def project do
    [
      app: :razer_beam,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      mod: {RazerBeam.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: RazerBeam.CLI]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"}
    ]
  end
end
