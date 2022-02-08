defmodule Repo.Migrations.CreateAudience do
  use Ecto.Migration

  def change do
    create table("audience") do
      add(:name, :string, null: false)
      add(:enabled, :boolean, null: false, default: true)

      # Timestamps
      add(:deleted_at, :utc_datetime_usec, null: true, default: nil)
    end
  end
end
