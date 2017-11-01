defmodule EstacionappServer.GarageView do
  use EstacionappServer.Web, :view

  def render("search.json", %{garages: garages}) do
    %{
      garages: render_many(garages, __MODULE__, "show.json")
    }
  end

  def render("show.json", %{garage: garage}) do
    %{
      id: garage.id,
      email: garage.email,
      name: garage.name,
      location: render_one(garage.location, __MODULE__, "location.json", as: :location),
      distance: garage.distance,
      pricing: render_one(garage.pricing, __MODULE__, "pricing.json", as: :pricing),
      outline: render_many(garage.outline, __MODULE__, "outline.json", as: :outline),
      amenities: Enum.map(garage.amenities, fn(am) -> am.description end)
    }
  end

  def render("pricing.json", %{pricing: pricing}) do
    %{
      id: pricing.id,
      bike: pricing.bike,
      car: pricing.car,
      pickup: pricing.pickup
    }
  end

  def render("outline.json", %{outline: outline}) do
    %{
      x: outline.x,
      y: outline.y
    }
  end

  def render("location.json", %{location: location}) do
    {long, lat} = location.coordinates
    [long, lat]
  end
end
