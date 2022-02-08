defmodule Repo do
  use Ecto.Repo,
    otp_app: :composable_ecto_queries,
    adapter: Ecto.Adapters.Postgres
end
