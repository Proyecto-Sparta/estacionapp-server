defmodule EstacionappServer.Repo.Migrations.AddLayoutsParkingSpaces do
  use Ecto.Migration

  def change do
    alter table(:garage_layouts) do
      add :parking_spaces, :geometry
    end
  end
end
