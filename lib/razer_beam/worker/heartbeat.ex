defmodule RazerBeam.Worker.Heartbeat do
  use GenServer, restart: :transient

  alias RazerBeam.Http.ChromaSDKSession
  alias RazerBeam.Model.Session
  alias RazerBeam.Worker

  require Logger

  @tick_interval 1000

  def start_link(initial_state \\ %Session{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(session) do
    heartbeat()

    {:ok, session}
  end

  # Callbacks
  def handle_info(:heartbeat, %Session{uri: nil, sessionid: nil}) do
    send(self(), :heartbeat)

    {:noreply, Worker.CreateSession.get_state()}
  end

  def handle_info(:heartbeat, %Session{uri: _uri} = session) do
    ChromaSDKSession.heartbeat(session)

    heartbeat()

    {:noreply, session}
  end

  defp heartbeat() do
    Process.send_after(self(), :heartbeat, @tick_interval)
  end
end
