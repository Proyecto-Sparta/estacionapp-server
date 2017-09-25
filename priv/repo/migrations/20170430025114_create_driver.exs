defmodule EstacionappServer.Repo.Migrations.CreateDriver do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :username, :string
      add :password, :string
      add :full_name, :string
      add :email, :string

      timestamps()
    end
    create unique_index(:drivers, [:username])
  end
end
