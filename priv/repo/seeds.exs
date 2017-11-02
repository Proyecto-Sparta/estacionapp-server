# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EstacionappServer.Repo.insert!(%EstacionappServer.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias EstacionappServer.{Repo, Garage, Driver, Amenity, Utils}

create_garage = fn name, coordinates ->
  Garage.changeset( %Garage{},
    %{username: name,
            password: "password",
            name: name,
            email: name <> "@gmail.com",
            location: Utils.Gis.make_coordinates(coordinates),
            pricing: %{car: 0, bike: 0, pickup: 0},
            outline: [%{x: 0, y: 0}, %{x: 0, y: 1}, %{x: 1, y: 1}, %{x: 1, y: 0}],
            amenities: [0, 1, 2, 3, 8]
    }
  )
end

create_amenity = fn desc, id ->
  %Amenity{description: desc, id: id}
end

create_driver = fn name ->
  %Driver{username: name,
          password: "password",
          full_name: name,
          email: name <> "@gmail.com",
          vehicle: %{type: "pickup", plate: "BIG TRUCK"}
  }
end

[create_amenity.("bici", 0),
 create_amenity.("auto", 1),
 create_amenity.("camioneta", 2),
 create_amenity.("llaves", 3),
 create_amenity.("lavado", 4),
 create_amenity.("inflador", 5),
 create_amenity.("hours_24", 6),
 create_amenity.("techado", 7),
 create_amenity.("manejan", 8)]
  |> Enum.each(&Repo.insert!/1)

[create_driver.("Chris McCord"), create_driver.("Ellon Musk")]
  |> Enum.each(&Repo.insert!/1)


[create_garage.("Taurusmania", [-34.587792, -58.414531]),
 create_garage.("Garage Prada SRL", [-34.590053, -58.404017]),
 create_garage.("Parking Costa Rica SRL", [-34.586979, -58.428994]),
 create_garage.("Apart Car Recoleta II", [-34.595600, -58.399725]),
 create_garage.("La Cortada", [-34.600472, -58.376918]),
 create_garage.("Garage", [-34.605203, -58.383613]),
 create_garage.("Apart Car Monserrat", [-34.613369, -58.383643]),
 create_garage.("Apart Car Madero Marie", [-34.620637, -58.366168])]
  |> Enum.each(&Repo.insert!/1)



