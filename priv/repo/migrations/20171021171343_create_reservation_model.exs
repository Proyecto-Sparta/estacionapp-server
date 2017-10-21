defmodule EstacionappServer.Repo.Migrations.CreateReservationModel do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :parking_space_id, :string
      add :garage_layout_id, references(:garage_layouts)      
      add :driver_id, references(:drivers)
      add :status, :integer

      timestamps()
    end
  end
end
