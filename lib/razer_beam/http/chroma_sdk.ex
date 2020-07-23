defmodule RazerBeam.Http.ChromaSDK do
  use HTTPoison.Base

  require Logger
  alias RazerBeam.Model.{Application, Session}

  def create_session() do
    case post("", %Application{}) do
      {:ok,
       %HTTPoison.Response{status_code: 200, body: %{"sessionid" => sessionid, "uri" => uri}}} ->
        %Session{sessionid: sessionid, uri: uri}

      _ ->
        %Session{}
    end
  end

  def process_request_headers(headers), do: [{"Content-Type", "application/json"}] ++ headers
  def process_request_url(url), do: "http://localhost:54235/razer/chromasdk" <> url
  def process_request_body(body), do: body |> Jason.encode!()
  def process_response_body(body), do: body |> Jason.decode!()

  def process_request_options(options) do
    [
      hackney: [
        pool: :razer_sdk
      ]
    ] ++ options
  end
end
