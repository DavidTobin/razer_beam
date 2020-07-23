defmodule RazerBeam.Worker.Effect do
  use GenServer, restart: :transient

  alias RazerBeam.Http.ChromaSDKSession
  alias RazerBeam.Model.{Session, Effect, Device}
  alias RazerBeam.Worker

  require Logger

  @tick_interval 60 * 255
  @all_devices [
    %Device{name: "keyboard"},
    %Device{name: "mouse"},
    %Device{name: "mousepad"},
    %Device{name: "chromalink"}
  ]

  def start_link(initial_state \\ %Session{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(session) do
    send(self(), :loop)

    {:ok, session}
  end

  # Callbacks
  def handle_info(:loop, %Session{uri: nil, sessionid: nil}) do
    send(self(), :loop)

    {:noreply, Worker.CreateSession.get_state()}
  end

  def handle_info(:loop, %Session{uri: _uri} = session) do
    for b <- 0..255,
        do:
          Process.send_after(
            self(),
            {:set_color, parse_bgr([b, rem(b + 100, 150), rem(b + 255, 355)])},
            60 * b + 1
          )

    loop()

    {:noreply, session}
  end

  def handle_info({:set_color, color}, %Session{uri: _uri} = session) do
    Enum.map(@all_devices, fn device ->
      ChromaSDKSession.set_static(session, device, %Effect.Static{
        param: %{color: color}
      })
    end)

    {:noreply, session}
  end

  defp loop() do
    Process.send_after(self(), :loop, @tick_interval)
  end

  defp parse_bgr(colors) do
    colors |> inspect |> Logger.info()

    with colors_hex <- Enum.map(colors, fn n -> Integer.to_string(n, 16) end),
         leading_zero <-
           Enum.map(colors_hex, fn n ->
             case String.length(n) do
               1 -> "0" <> n
               _ -> n
             end
           end),
         hex_string <-
           leading_zero
           |> Enum.join("") do
      {c, _} = Integer.parse("00#{hex_string}", 16)

      c
    end
  end
end
