use Mix.Config

# Configure your database
config :crawlexir, Crawlexir.Repo,
  username: "postgres",
  password: "postgres",
  database: "crawlexir_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crawlexir, CrawlexirWeb.Endpoint,
  http: [port: 4002],
  server: false

config :crawlexir, Oban,
  repo: Crawlexir.Repo,
  crontab: false,
  queues: false,
  prune: :disabled

# Print only warnings and errors during test
config :logger, level: :warn
