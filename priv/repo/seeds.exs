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

alias EstacionappServer.{Repo, Garage}

create_garage = fn name, coordinates ->
  %Garage{username: "#{name} #{Enum.random(0..100)}",
          garage_name: name,
          email: name <> "@gmail.com",
          location: %Geo.Point{srid: 4326, coordinates: coordinates}}
end

[create_garage.("Apart Car Palermo", {-58.412675, -34.578403}),
 create_garage.("Taurusmania", {-58.414531, -34.587792}),
 create_garage.("Garage Prada SRL", {-58.404017, -34.590053}),
 create_garage.("Parking Costa Rica SRL", {-58.428994, -34.586979}),
 create_garage.("Apart Car Recoleta II", {-58.399725, -34.595600}),
 create_garage.("La Cortada", {-58.376918, -34.600472}),
 create_garage.("Garage", {-58.383613, -34.605203}),
 create_garage.("Apart Car Monserrat", {-58.383643, -34.613369}),
 create_garage.("Apart Car Madero Marie", {-58.366168, -34.620637})]
  |> Enum.each(fn garage -> Repo.insert!(garage) end)
