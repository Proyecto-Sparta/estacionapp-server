defmodule EstacionappServer.GarageTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.{Garage, Utils}

  import EstacionappServer.Factory

  @valid_attrs %{email: "medrano950@gmail.com",
                 name: "Medrano Parking",
                 username: "medranoParking",
                 location: Utils.Gis.make_coordinates([0,0]),
                 password: "password",
                 pricing: %{bike: 0, car: 0, pickup: 0},
                 outline: [%{x: 0, y: 0}]
                }

  @invalid_attrs %{}

  describe "changeset" do

    test "with valid attributes" do
      changeset = Garage.changeset(%Garage{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Garage.changeset(%Garage{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "amenities" do

    test "are changed" do
      garage = insert(:garage) |> Repo.preload(:amenities)

      assert garage.amenities == []

      a1 = insert(:amenity)
      a2 = insert(:amenity, description: "Foobar")

      garage = garage
        |> Garage.changeset(%{amenities: [a1.id, a2.id]})
        |> Repo.update!
        |> Repo.preload(:amenities)

      assert garage.amenities == [a1, a2]
    end
  end

  describe "close_to" do

    test "close_to returns all garages without max_distance" do
      insert(:garage)
      insert(:garage, username: "Devoto Parking")
      garages = garages_close_to_devoto()

      assert Enum.count(garages) == 2
    end

    test "close_to with max_distance filters garages" do
      insert(:garage)
      insert(:garage, username: "Devoto Parking",
             location: Utils.Gis.make_coordinates([-34.597524, -58.515372]))
      garages = garages_close_to_devoto(%{"max_distance" => 400})

      assert Enum.count(garages) == 1
    end

    test "close_to inserts distance" do
      insert(:garage)
      [garage] = garages_close_to_devoto()

      assert garage.distance == 16591
    end
  end

  defp garages_close_to_devoto(params \\ %{}) do
    devoto_square = Utils.Gis.make_coordinates([-34.5993687, -58.5122663])
    params
      |> Map.put_new("max_distance", nil)
      |> Map.put("location", devoto_square)
      |> Garage.close_to
  end
end
