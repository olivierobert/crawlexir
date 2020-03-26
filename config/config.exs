# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :crawlexir,
  ecto_repos: [Crawlexir.Repo]

# Configures the endpoint
config :crawlexir, CrawlexirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XOgrFAIPdjk6MBHhhddbjdbsun0dL2zSKuOXqg2QN4EjbVYee1xzSrGdk0u85JfU",
  render_errors: [view: CrawlexirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Crawlexir.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "9NhrdwT2"]

config :crawlexir, Oban,
 repo: Crawlexir.Repo,
 prune: {:maxlen, 10_000},
 queues: [default: 20]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
