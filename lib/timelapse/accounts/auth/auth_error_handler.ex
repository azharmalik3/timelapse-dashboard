defmodule Timelapse.Auth.AuthErrorHandler do
  use TimelapseWeb, :controller
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)
    conn
    |> put_resp_content_type("text/plain")
    |> redirect(to: "/")
  end
end
