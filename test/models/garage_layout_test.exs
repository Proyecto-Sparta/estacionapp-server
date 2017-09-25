defmodule EstacionappServer.GarageLayoutTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.GarageLayout

  @valid_attrs %{floor_level: 1, parking_spaces: %Geo.GeometryCollection{geometries: [%Geo.Point{coordinates: {0, 0}}]}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GarageLayout.changeset(%GarageLayout{}, @valid_attrs)
    EstacionappServer.Repo.insert!(changeset)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GarageLayout.changeset(%GarageLayout{}, @invalid_attrs)
    refute changeset.valid?
  end
end
