defmodule TimelapseWeb.Router do
  use TimelapseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug :protect_from_forgery
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

    post "/timelapse", TimelapseController, :create
    get "/gallery/json", VideoController, :get_videos
    get "/timelapse", RooterController, :main
    get "/watch/:id", RooterController, :main
    get "/watch/single/:id", WatchController, :show
    get "/gallery", RooterController, :main
    get "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimelapseWeb do
  #   pipe_through :api
  # end
end
