# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :timelapse,
  ecto_repos: [Timelapse.Repo]

# Configures the endpoint
config :timelapse, TimelapseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "azYC3LCJnCyTJPtKVbUb0aSaI3d9A2AGCG1mUzYZNunebufL0kbgKJKNaLLLjb/U",
  render_errors: [view: TimelapseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Timelapse.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :timelapse, Timelapse.Auth.Guardian,
  issuer: "timelapse",
  secret_key: "zT0xPNd6iQSS5kifbW5GskxSZvLPFgwLdwnsbGv+wtFzEK2hrSZXdDDOwz3ctpPu"

config :timelapse, Timelapse.Auth.AuthAccessPipeline,
  module: Timelapse.Auth.Guardian,
  error_handler: Timelapse.Auth.AuthErrorHandler

config :hound, browser: "chrome"

config :ex_aws,
  access_key_id: System.get_env["AWS_ACCESS_KEY_ID"]
  secret_access_key: System.get_env["SECRET_ACCESS_KEY"]
  region: "eu-west-1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
