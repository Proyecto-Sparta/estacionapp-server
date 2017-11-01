defmodule EstacionappServer.Repo.Migrations.AddGarageOutline do
  use Ecto.Migration

  def change do
    alter table :drivers do
      add :outline, {:array, :map}
    end
  end
end
