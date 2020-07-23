defmodule RazerBeam.Worker.CreateSession do
  use GenServer, restart: :transient

  alias RazerBeam.Http.{ChromaSDK, ChromaSDKSession}
  alias RazerBeam.Model.Session

  require Logger

  def start_link(initial_state \\ %Session{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Creating session...")

    work()

    {:ok, state}
  end

  def terminate(_reason, %Session{uri: uri}) do
    Logger.info("Going down...")

    ChromaSDKSession.delete(uri)

    :normal
  end

  def terminate(_reason, _state), do: :normal

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  # Callbacks
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_info(:work, %Session{uri: nil, sessionid: nil}) do
    work()

    {:noreply, ChromaSDK.create_session()}
  end

  def handle_info(:work, %Session{} = state) do
    work()

    {:noreply, state}
  end

  defp work(), do: Process.send_after(self(), :work, 1000)
end
