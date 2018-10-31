defmodule TimelapseWeb.PageController do
  use TimelapseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
