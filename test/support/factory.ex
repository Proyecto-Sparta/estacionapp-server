defmodule EstacionappServer.Factory do
  use ExMachina.Ecto, repo: EstacionappServer.Repo

  alias EstacionappServer.{Garage, Utils}

    def garage_factory do
      %Garage{username: "garageuser123",
      garage_name: "Torcuato Parking",
      email: "tparking@gmail.com",
      location: Utils.Gis.make_coordinates([-34.480666, -58.622210])}
    end
end