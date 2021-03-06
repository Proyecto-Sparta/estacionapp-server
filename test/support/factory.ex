defmodule EstacionappServer.Factory do
  use ExMachina.Ecto, repo: EstacionappServer.Repo

  alias EstacionappServer.{Garage, Driver, Utils, GarageLayout, Amenity, Reservation}

    def garage_factory do
      %Garage{
        username: "garageuser123",
        name: "Torcuato Parking",
        email: "tparking@gmail.com",
        location: Utils.Gis.make_coordinates([-34.480666, -58.622210]),
        password: Utils.Crypto.encrypt("password"),
        outline: [%{x: 0, y: 0}, %{x: 1, y: 1}],
        pricing: %{
          car: 15,
          bike: 23,
          pickup: 88
        }
      }
    end

    def driver_factory do
      %Driver{
        username: "joValim",
        full_name: "Jose Valim",
        email: "jvalim@plataformatec.br",
        password: Utils.Crypto.encrypt("password"),
        vehicle: %{
          type: "car",
          plate: "ELX-RLZ"}
      }
    end

    def garage_layout_factory do
      %GarageLayout{
        floor_level: 1,
        parking_spaces: [
          %{id: "foo", x: 0, y: 0, height: 10, width: 15, occupied: true, shape: "square", angle: 0}
        ]
      }
    end

    def amenity_factory do
      %Amenity{description: "Lavamos autos"}
    end

    def reservation_factory do
      %Reservation{valid: false}
    end
end
