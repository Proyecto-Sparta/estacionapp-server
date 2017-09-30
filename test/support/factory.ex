defmodule EstacionappServer.Factory do
  use ExMachina.Ecto, repo: EstacionappServer.Repo

  alias EstacionappServer.{Garage, Driver, Utils}

    def garage_factory do
      %Garage{
        username: "garageuser123",
        name: "Torcuato Parking",
        email: "tparking@gmail.com",
        location: Utils.Gis.make_coordinates([-34.480666, -58.622210]),
        password: "password",
        pricing: %{
          car: 0,
          bike: 0,
          pickup: 0
        }
      }
    end

    def driver_factory do
      %Driver{
        username: "joValim",
        full_name: "Jose Valim",
        email: "jvalim@plataformatec.br",
        password: "password"
      }
    end
end
