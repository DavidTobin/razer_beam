defmodule RazerBeam.Http.ChromaSDKSession do
  use HTTPoison.Base
  require Logger

  alias RazerBeam.Model.{Session, Effect, Device}

  defguard is_valid_session?(uri) when uri != nil

  def delete(%Session{uri: uri} = _session) when is_valid_session?(uri) do
    delete(uri, [], [])
  end

  def heartbeat(%Session{uri: uri}) when is_valid_session?(uri) do
    put(uri <> "/heartbeat", [], [])
  end

  def set_static(
        %Session{uri: uri},
        %Device{name: device_name},
        %Effect.Static{} = effect
      )
      when is_valid_session?(uri) do
    put(uri <> "/#{device_name}", effect)
  end

  def set_custom(
        %Session{uri: uri},
        %Device{name: device_name},
        %Effect.Custom{} = effect
      )
      when is_valid_session?(uri) do
    case post(uri <> "/#{device_name}", effect) do
      {:ok, res} ->
        Logger.info(inspect(res))
        {:ok, res}

      a ->
        Logger.info(inspect(a))
        a
    end
  end

  def process_request_headers(headers), do: [{"Content-Type", "application/json"}] ++ headers
  def process_request_body(body), do: body |> Jason.encode!()
  def process_response_body(body), do: body |> Jason.decode!()

  def process_request_options(options) do
    [
      hackney: [
        pool: :razer_sdk_session
      ]
    ] ++ options
  end
end
