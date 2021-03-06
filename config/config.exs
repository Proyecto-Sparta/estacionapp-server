# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :estacionapp_server,
  ecto_repos: [EstacionappServer.Repo]

# Configures the endpoint
config :estacionapp_server, EstacionappServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "seFBbagPp2LXQEo+SwbbtB2geeqV9mflEgntnhYxbswT6os3Tcdqet09WBoC1i8L",
  render_errors: [view: EstacionappServer.ErrorView, accepts: ~w(json)],
  pubsub: [name: EstacionappServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  secret_key: "+dYRbUmvLGXTMQ+",
  serializer: EstacionappServer.GuardianSerializer

config :estacionapp_server, EstacionappServer.Repo,
  types: EstacionappServer.GeoTypes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
