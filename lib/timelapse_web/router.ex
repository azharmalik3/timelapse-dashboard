defmodule TimelapseWeb.Router do
  use TimelapseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Timelapse.Auth.AuthAccessPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", TimelapseWeb do
    pipe_through [:browser, :auth]

    get "/", SessionController, :new
    resources "/sessions", SessionController, only: [:new, :create]
  end

  scope "/", TimelapseWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/timelapse", TimelapseController
    resources "/sessions", SessionController, only: [:delete]
    resources "/videos", VideoController
    get "/watch/:id", WatchController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimelapseWeb do
  #   pipe_through :api
  # end
end
