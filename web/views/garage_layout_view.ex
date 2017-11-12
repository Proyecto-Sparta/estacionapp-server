defmodule EstacionappServer.GarageLayoutView do
  use EstacionappServer.Web, :view

  def render("index.json", %{layouts: layouts}) do
    %{
      layouts: render_many(layouts, __MODULE__, "show.json", as: :garage_layout)
    }
  end

  def render("show.json", %{garage_layout: garage_layout}) do
    %{
      id: garage_layout.id,
      floor_level: garage_layout.floor_level,
      parking_spaces: garage_layout.parking_spaces
    }
  end
end
