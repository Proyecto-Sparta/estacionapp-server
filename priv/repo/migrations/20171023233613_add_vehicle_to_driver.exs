defmodule EstacionappServer.Repo.Migrations.AddVehicleToDriver do
  use Ecto.Migration

  def change do
    alter table :drivers do
      add :vehicle, :map
    end
  end
end
