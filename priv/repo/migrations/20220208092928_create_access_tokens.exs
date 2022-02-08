defmodule Repo.Migrations.CreateAccessTokens do
  use Ecto.Migration

  def change do
    create table("access_tokens") do
      add(:issuer_id, references("issuers", type: :bigserial, on_delete: :delete_all),
        null: false
      )
      add(:audience_id, references("audience", type: :bigserial, on_delete: :delete_all),
        null: true
      )

      add(:expires_in, :integer, null: false, default: 3600)

      # Timestamps
      add(:created_at, :utc_datetime_usec, null: false, default: fragment("CURRENT_TIMESTAMP"))
      add(:revoked_at, :utc_datetime_usec, null: true, default: nil)
    end
  end
end
