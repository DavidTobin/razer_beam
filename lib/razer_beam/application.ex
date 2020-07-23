defmodule RazerBeam.Application do
  use Application

  def start(_type \\ :razer_beam, _args \\ []) do
    import Supervisor.Spec

    alias RazerBeam.Http.{ChromaSDK, ChromaSDKSession}
    alias RazerBeam.Worker.{CreateSession, Heartbeat, Effect}

    children = [
      supervisor(CreateSession, [], restart: :permanent),
      worker(Heartbeat, [], restart: :permanent),
      worker(Effect, [], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: RazerBeam.Application]

    ChromaSDK.start()
    ChromaSDKSession.start()

    Supervisor.start_link(children, opts)
  end
end
