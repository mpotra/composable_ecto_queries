import Config

config :composable_ecto_queries,
  ecto_repos: [Repo]

config :composable_ecto_queries, Repo,
  database: "composable_ecto_queries_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 7432

import_config "#{config_env()}.exs"
