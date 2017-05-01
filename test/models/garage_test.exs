defmodule EstacionappServer.GarageTest do
  use EstacionappServer.ModelCase
  import EstacionappServer.Factory

  alias EstacionappServer.{Garage, Utils}

  @valid_attrs %{email: "medrano950@gmail.com",
                 garage_name: "Medrano Parking",
                 username: "medranoParking",
                 location: Utils.Gis.make_coordinates([0,0]) }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Garage.changeset(%Garage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Garage.changeset(%Garage{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "close_to returns all garages without max_distance" do
    insert(:garage)
    insert(:garage, username: "Devoto Parking")
    garages = garages_close_to_devoto()

    assert Enum.count(garages) == 2
  end

  test "close_to with max_distance filters garages" do
    insert(:garage)
    garages = garages_close_to_devoto(%{"max_distance" => 500})

    assert Enum.count(garages) == 0
  end

  test "close_to inserts distance" do
    insert(:garage)
    [garage] = garages_close_to_devoto()

    assert garage.distance == 16591
  end

  defp garages_close_to_devoto(distance \\ %{}) do
    devoto_square = Utils.Gis.make_coordinates([-34.5993687, -58.5122663])
    location = %{"location" => devoto_square}
    Garage.close_to(Map.merge(distance, location))
  end
end

