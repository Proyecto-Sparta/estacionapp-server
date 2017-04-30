defmodule EstacionappServer.GarageTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.Garage

  @valid_attrs %{email: "medrano950@gmail.com",
                 garage_name: "Medrano Parking",
                 username: "medranoParking",
                 location: %Geo.Point{coordinates: {0, 0}, srid: 4326} }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Garage.changeset(%Garage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Garage.changeset(%Garage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
