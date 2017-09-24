defmodule EstacionappServer.Repo.Migrations.CreateGarageLayout do
  use Ecto.Migration

  def change do
    create table(:garage_layouts) do
      add :floor_level, :integer
      add :garage_id, references(:garages, on_delete: :delete_all)      

      timestamps()
    end
  end
end
