defmodule AccessToken do
  @moduledoc """
  The AccessToken schema represents database records of access tokens
  issued by an Issuer and that have a target Audience.

  For the purpose of this example, Access Tokens are just records
  that are identified by IDs.

  One possible application of such records is to reference database
  records via the JTI claim in JSON Web Tokens (JWT)

  More information available at
  https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.7
  """
  use Ecto.Schema

  alias Issuer
  alias Audience

  schema "access_tokens" do
    # The Issuer record that issued the token
    belongs_to(:issuer, Issuer, foreign_key: :issuer_id)

    # The Audience record that this token is intended for
    belongs_to(:audience, Audience, foreign_key: :audience_id)

    # Number of seconds the token expires after its creation
    field(:expires_in, :integer, null: false)

    # DateTime when the token was created by the Issuer
    field(:created_at, :utc_datetime_usec)
    # DateTime when the token was revoked and can no longer be used.
    field(:revoked_at, :utc_datetime_usec)
  end
end
