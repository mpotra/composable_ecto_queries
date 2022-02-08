import Config

config :composable_ecto_queries, Repo, pool: Ecto.Adapters.SQL.Sandbox

config :logger,
  level: :debug
