defmodule RazerBeam.CLI do
  require Logger

  def start() do
    RazerBeam.Application.start(:razer_beam, [])
  end

  def main(_args \\ []) do
    Logger.info("Starting Razer Beam...")

    :timer.sleep(:infinity)
  end
end
