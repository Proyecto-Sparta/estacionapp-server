defmodule EstacionappServer.Repo.Migrations.CreateGarage do
  use Ecto.Migration

  def change do
    create table(:garages) do
      add :username, :string
      add :password, :string
      add :garage_name, :string
      add :email, :string

      timestamps()
    end
    execute("SELECT AddGeometryColumn ('garages', 'location', 4326, 'POINT', 2);")
    execute("CREATE INDEX gis_index on garages USING GIST(location);")
    create unique_index(:garages, [:username])
  end
end
