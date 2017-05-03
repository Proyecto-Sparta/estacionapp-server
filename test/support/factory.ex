defmodule EstacionappServer.Factory do
  use ExMachina.Ecto, repo: EstacionappServer.Repo

  alias EstacionappServer.{Garage, Driver, Utils}

    def garage_factory do
      %Garage{username: "garageuser123",
      garage_name: "Torcuato Parking",
      email: "tparking@gmail.com",
      location: Utils.Gis.make_coordinates([-34.480666, -58.622210])}
    end

    def driver_factory do
      %Driver{username: "joValim",
      full_name: "Jose Valim",
      email: "jvalim@plataformatec.br"}
    end
end