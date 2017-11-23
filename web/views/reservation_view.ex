defmodule EstacionappServer.ReservationView do
  use EstacionappServer.Web, :view

  def render("show.json", %{reservation: reservation}) do
    %{
      id: reservation.id,
      driver: render_one(reservation.driver, EstacionappServer.DriverView, "driver.json", as: :driver),
      parking_space_id: reservation.parking_space_id
    }
  end
end
