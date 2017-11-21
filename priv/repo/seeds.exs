# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EstacionappServer.Repo.insert!(%EstacionappServer.SomeModel{}}
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on} as they will fail if something goes wrong.
alias EstacionappServer.{Repo, Garage, Driver, Amenity, Utils, Seeds, GarageLayout}

defmodule EstacionappServer.Seeds do

  def build_garage({name, coordinates}) do
    Garage.changeset( %Garage{}, %{
      username: name,
      password: "password",
      name: name,
      email: name <> "@gmail.com",
      location: Utils.Gis.make_coordinates(coordinates),
      pricing: %{car: 0, bike: 0, pickup: 0},
      outline: [%{x: 25, y: 18 }, %{x: 855, y: 13}, %{x: 858, y: 576}, %{x: 45, y: 579}],
      amenities: [1, 2, 3, 4, 9]
    })
  end

  def build_amenity({description, id}), do: Amenity.changeset(%Amenity{}, %{description: description, id: id})

  def build_driver(name) do
    Driver.changeset(%Driver{}, %{
      username: name,
      password: "password",
      full_name: name,
      email: name <> "@gmail.com",
      vehicle: %{type: "pickup", plate: "BIG TRUCK"}
    })
  end
  def build_garage_layout(id) do
    GarageLayout.changeset(%GarageLayout{}, %{
      garage_id: id, floor_level: 1, parking_spaces: [
        %{ x: 100, y: 100, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 100, y: 250, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 100, y: 400, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 450, y: 100, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 450, y: 250, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 450, y: 400, width: 75, height: 100, occupied: true , shape: "square", angle: 0 },
        %{ x: 550, y: 100, width: 75, height: 100, occupied: false, shape: "square", angle: 0 },
        %{ x: 550, y: 250, width: 75, height: 100, occupied: false, shape: "square", angle: 0 },
        %{ x: 550, y: 400, width: 75, height: 100, occupied: true , shape: "square", angle: 0 }
      ]
    })
  end
end

~W(bici auto camioneta llaves lavado inflador hours_24 techado manejan)
  |> Stream.with_index
  |> Enum.map(&Seeds.build_amenity/1)
  |> Enum.map(&Repo.insert!/1)

["Chris McCord", "Ellon Musk"]
  |> Enum.map(&Seeds.build_driver/1)
  |> Enum.map(&Repo.insert!/1)

[{"Taurusmania", [-34.587792, -58.414531]},
 {"Garage Prada SRL", [-34.590053, -58.404017]},
 {"Parking Costa Rica SRL", [-34.586979, -58.428994]},
 {"Apart Car Recoleta II", [-34.595600, -58.399725]},
 {"La Cortada", [-34.600472, -58.376918]},
 {"Garage", [-34.605203, -58.383613]},
 {"Apart Car Monserrat", [-34.613369, -58.383643]},
 {"Apart Car Madero Marie", [-34.620637, -58.366168]}]
   |> Enum.map(&Seeds.build_garage/1)
   |> Enum.map(&Repo.insert!/1)

[1, 2, 3, 4, 5, 6, 7, 8]
  |> Enum.map(&Seeds.build_garage_layout/1)
  |> Enum.map(&Repo.insert!/1)
