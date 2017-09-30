defmodule EstacionappServer.Repo.Migrations.AddPricingColumn do
  use Ecto.Migration

  def change do
    alter table(:garages) do      
      add :pricing,  :map
    end
  end
end
