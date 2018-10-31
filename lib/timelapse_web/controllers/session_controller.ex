defmodule TimelapseWeb.SessionController do
  use TimelapseWeb, :controller
  alias Timelapse.Accounts.User
  alias Timelapse.Accounts.Guardian
  import Timelapse.Auth, only: [current_user: 1]

  def new(conn, _) do
    with %User{} <- current_user(conn) do
      conn
      |> redirect(to: "/timelapse")
    else
      _ ->
        conn
        |> render("new.html", csrf_token: get_csrf_token())
    end
  end

  def create(conn, %{"session" => %{"username" => user, "password" => password}}) do
    case Timelapse.Auth.authenticate_user(user, password) do
      {:ok, user} ->
        conn
        |> Timelapse.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: timelapse_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Timelapse.Auth.logout()
    |> redirect(to: session_path(conn, :new))
  end
end
