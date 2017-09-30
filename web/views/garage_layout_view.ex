defmodule EstacionappServer.GarageLayoutView do
  use EstacionappServer.Web, :view

  def render("index.json", %{layouts: layouts}) do
    %{
      layouts: render_many(layouts, __MODULE__, "show.json")
    }
  end

  def render("show.json", %{garage_layout: layout}) do
    %{
      id: layout.id,
      floor_level: layout.floor_level,
      parking_spaces: layout.parking_spaces
    }
  end
end
