defmodule Issuer do
  @moduledoc """
  The issuer schema represents database records of servers or application
  identities that generate access tokens for specific audience and subjects.

  For further details please consult
  https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3
  """

  use Ecto.Schema

  schema "issuers" do
    field(:name, :string, null: false)

    field(:enabled, :boolean)

    field(:deleted_at, :utc_datetime_usec)
  end
end
