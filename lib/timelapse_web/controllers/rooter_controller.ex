defmodule TimelapseWeb.RooterController do
  use TimelapseWeb, :controller
  import Timelapse.Auth, only: [current_user: 1]

  def main(conn, _params) do
    render(conn, "main.html", user: current_user(conn))
  end
end
