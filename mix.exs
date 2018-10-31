defmodule Timelapse.Mixfile do
  use Mix.Project

  def project do
    [
      app: :timelapse,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Timelapse.Application, []},
      applications: app_list(Mix.env),
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp app_list(:dev), do: [:dotenv, :credo | app_list()]
  defp app_list(:test), do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()
  defp app_list, do: [
    :phoenix,
    :phoenix_pubsub,
    :phoenix_ecto,
    :postgrex,
    :phoenix_html,
    :phoenix_live_reload,
    :gettext,
    :cowboy,
    :credo,
    :mix_test_watch,
    :ex_guard,
    :dialyxir,
    :guardian,
    :comeonin,
    :bcrypt_elixir,
    :hound,
    :plug,
    :sweet_xml,
    :httpoison,
    :ex_aws,
    :ex_aws_s3,
    :configparser_ex,
    :mogrify
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:ex_guard, "~> 1.3", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:guardian, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:hound, "~> 1.0"},
      {:plug, "~> 1.6.4"},
      {:sweet_xml, "~> 0.6.5"},
      {:httpoison, "~> 1.2"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:configparser_ex, "~> 2.0"},
      {:mogrify, "~> 0.6.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
