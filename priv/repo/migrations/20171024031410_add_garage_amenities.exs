defmodule EstacionappServer.Repo.Migrations.AddGarageAmenities do
  use Ecto.Migration

  def change do
    create table(:amenities) do
      add :description, :string

      timestamps()
    end

    create unique_index(:amenities, [:description])

    create table(:garages_amenities, primary_key: false) do
      add :garage_id, references(:garages)
      add :amenity_id, references(:amenities)
    end

    create unique_index(:garages_amenities, [:garage_id, :amenity_id])
  end
end
