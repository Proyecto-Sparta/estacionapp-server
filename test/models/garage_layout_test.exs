defmodule EstacionappServer.GarageLayoutTest do
  use EstacionappServer.ModelCase

  import EstacionappServer.Factory  

  alias EstacionappServer.GarageLayout
  
  test "changeset with valid attributes" do
    %{:id => garage_id} = insert(:garage)

    parking_spaces = [%{x: 1, y: 0, height: 10, width: 15, ocupied?: false, shape: "square", angle: 0}]

    valid_params = %{garage_id: garage_id, floor_level: 1, parking_spaces: parking_spaces}

    changeset = GarageLayout.changeset(%GarageLayout{}, valid_params)
    EstacionappServer.Repo.insert!(changeset)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GarageLayout.changeset(%GarageLayout{}, %{})
    refute changeset.valid?
  end
end
