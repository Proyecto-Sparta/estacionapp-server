defmodule EstacionappServer.GarageLayoutView do
  use EstacionappServer.Web, :view

  alias EstacionappServer.GarageLayout

  def render("index.json", %{garage_layouts: layouts}) do
    %{
      layouts: render_many(layouts, __MODULE__, "show.json", as: :garage_layout)
    }
  end

  def render("show.json", %{garage_layout: garage_layout}) do
    %{
      id: garage_layout.id,
      floor_level: garage_layout.floor_level,
      parking_spaces: garage_layout.parking_spaces,
      reservations: render_many(garage_layout.reservations, EstacionappServer.ReservationView, "show.json", as: :reservation)
    }
  end
end
