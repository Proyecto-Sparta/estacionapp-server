defmodule EstacionappServer.Repo.Migrations.ChangedStatusForValidAttribute do
  use Ecto.Migration

  def change do
    alter table :reservations do
      remove :status
      add :valid?, :boolean, null: false
    end
  end
end
