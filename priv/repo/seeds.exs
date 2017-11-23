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

  def insert_garage(name, coordinates, pricing, outline, amenities) do
    Garage.changeset( %Garage{}, %{
      username: name,
      password: "password",
      name: name,
      email: name <> "@gmail.com",
      location: Utils.Gis.make_coordinates(coordinates),
      pricing: pricing,
      outline: outline,
      amenities: amenities
    }) |> Repo.insert!
  end

  def insert_amenity({description, id}), do: Amenity.changeset(%Amenity{}, %{description: description, id: id}) |> Repo.insert!

  def insert_driver(username, full_name, vehicle) do
    Driver.changeset(%Driver{}, %{
      username: username,
      password: "password",
      full_name: full_name,
      email: username <> "@gmail.com",
      vehicle: vehicle
    }) |> Repo.insert!
  end

  def insert_garage_layout(garage_id, floor_level, parking_spaces) do
    GarageLayout.changeset(%GarageLayout{}, %{
      garage_id: garage_id, 
      floor_level: floor_level, 
      parking_spaces: parking_spaces
    }) |> Repo.insert!
  end
end

~W(bici auto camioneta llaves lavado inflador hours_24 techado manejan)
  |> Stream.with_index
  |> Enum.map(&Seeds.insert_amenity/1)

#Datos de generales
Seeds.insert_driver("jnoziglia", "Julian Noziglia", %{type: "car", plate: "OUI 915"})
Seeds.insert_driver("erwincdl", "Erwin Debusschere", %{type: "bike", plate: "Shimano"})
Seeds.insert_driver("MarianoP", "Mariano Paolucci", %{type: "bike", plate: "Shimano Roja"})

#Square shape
general_outline = [%{x: 25, y: 18 }, %{x: 855, y: 13}, %{x: 858, y: 576}, %{x: 45, y: 579}]

Seeds.insert_garage("Garage Prada SRL", [-34.590053, -58.404017], %{car: 40, bike: 10, pickup: 110}, general_outline, [1,2,3,5])
Seeds.insert_garage("Taurusmania", [-34.587792, -58.414531], %{car: 55, bike: 12, pickup: 85}, general_outline, [1,2,3,5,6,7])
Seeds.insert_garage("Parking Costa Rica SRL", [-34.586979, -58.428994], %{car: 33, bike: 7, pickup: 77}, general_outline, [1,2,3,8])
Seeds.insert_garage("Apart Car Recoleta II", [-34.595600, -58.399725], %{car: 42, bike: 23, pickup: 88}, general_outline, [1,2,3])
Seeds.insert_garage("La Cortada", [-34.600472, -58.376918], %{car: 62, bike: 18, pickup: 92}, general_outline, [1,2,3,7,6])
Seeds.insert_garage("Garage", [-34.605203, -58.383613], %{car: 35, bike: 15, pickup: 70}, general_outline, [1,2,3,4,5,6,7,8])
Seeds.insert_garage("Apart Car Monserrat", [-34.613369, -58.383643], %{car: 44, bike: 15, pickup: 62}, general_outline, [1,2,3,5,6])
Seeds.insert_garage("Apart Car Madero Marie", [-34.620637, -58.366168], %{car: 32, bike: 22, pickup: 80}, general_outline, [1,2,3,7,8])


general_parking_spaces = [
  %{ x: 100, y: 100, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 100, y: 250, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 100, y: 400, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 450, y: 100, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 450, y: 250, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 450, y: 400, width: 60, height: 60, occupied: true , shape: "square", angle: 0 },
  %{ x: 550, y: 100, width: 60, height: 60, occupied: false, shape: "square", angle: 0 },
  %{ x: 550, y: 250, width: 60, height: 60, occupied: false, shape: "square", angle: 0 },
  %{ x: 550, y: 400, width: 60, height: 60, occupied: false , shape: "square", angle: 0 }
]


Seeds.insert_garage_layout(1, 1, general_parking_spaces)
Seeds.insert_garage_layout(2, 1, general_parking_spaces)
Seeds.insert_garage_layout(3, 1, general_parking_spaces)
Seeds.insert_garage_layout(4, 1, general_parking_spaces)
Seeds.insert_garage_layout(5, 1, general_parking_spaces)
Seeds.insert_garage_layout(6, 1, general_parking_spaces)
Seeds.insert_garage_layout(7, 1, general_parking_spaces)
Seeds.insert_garage_layout(8, 1, general_parking_spaces)

#Datos para demo
##Conductor
Seeds.insert_driver("fedescarpa", "Federico Scarpa", %{type: "pickup", plate: "AA 509 GD"})

#G1
Seeds.insert_garage("UTN parking", [-34.597890, -58.420338], %{bike: 0, car: 80, pickup: 120}, general_outline, [2, 3, 7])
#G2
Seeds.insert_garage("DISI parking", [-34.599137, -58.420287], %{bike: 0, car: 50, pickup: 90}, general_outline, [2, 3, 4, 5, 7, 8])
#G3
Seeds.insert_garage("Aparcamientos PROJECT", [-34.600359, -58.422099], %{bike: 15, car: 30, pickup: 80}, general_outline, [1, 2, 3, 8])

##Garage
#Franco
franco_outline = [%{x: 124, y: 40 }, %{x: 127, y: 285}, %{x: 526, y: 285}, %{x: 525, y: 42}]

Seeds.insert_garage("Mumuki aparcaderos", [-34.603168, -58.421574], %{bike: 10, car: 40, pickup: 70}, franco_outline, [1, 2, 3, 6, 7])

first_floor = [
  %{ x: 183, y: 123, width: 40, height: 40, occupied: true, shape: "square", angle: 0 },
  %{ x: 293, y: 124, width: 40, height: 40, occupied: true, shape: "square", angle: 0 },
  %{ x: 386, y: 124, width: 40, height: 40, occupied: true, shape: "square", angle: 0 }
]

second_floor = [
  %{ x: 271, y: 210, width: 40, height: 40, occupied: true, shape: "square", angle: 0 },
  %{ x: 144, y: 215, width: 40, height: 40, occupied: false, shape: "square", angle: 0 },
  %{ x: 401, y: 53, width: 40, height: 40, occupied: false, shape: "square", angle: 0 },
  %{ x: 272, y: 53, width: 40, height: 40, occupied: false, shape: "square", angle: 0 },
  %{ x: 147, y: 60, width: 40, height: 40, occupied: false, shape: "square", angle: 0 }
]

Seeds.insert_garage_layout(12, 1, first_floor)
Seeds.insert_garage_layout(12, 2, second_floor)
