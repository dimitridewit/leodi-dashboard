# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :leodi_dashboard,
  ecto_repos: [LeodiDashboard.Repo]

# Configures the endpoint
config :leodi_dashboard, LeodiDashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LiDgmmArVTu4ML58WnwtIAP2lj7nO4DoSODLw1so6krvshnv1XQmuv5kCHlxRbmB",
  render_errors: [view: LeodiDashboardWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LeodiDashboard.PubSub,
  live_view: [signing_salt: "MFHt1BBs"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :leodi_dashboard, :pow,
  user: LeodiDashboard.Users.User,
  repo: LeodiDashboard.Repo,
  web_module: LeodiDashboardWeb,
  extensions: [PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
