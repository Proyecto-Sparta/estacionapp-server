defmodule EstacionappServer.Repo.Migrations.RemovedQuestionMarkFromReservationValidField do
  use Ecto.Migration

  def change do
    rename table(:reservations), :valid?, to: :valid    
  end
end
