defmodule Audience do
  @moduledoc """
  The Audience schema represents database records of application
  identities that authorize requests based on access tokens.

  For further details please consult
  https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1
  """

  use Ecto.Schema

  schema "audience" do
    field(:name, :string, null: false)
    field(:enabled, :boolean)

    field(:deleted_at, :utc_datetime_usec)
  end
end
