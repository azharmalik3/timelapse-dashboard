defmodule Timelapse.Auth.AuthAccessPipeline do

  use Guardian.Plug.Pipeline, otp_app: :timelapse

  plug Guardian.Plug.VerifyCookie
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
