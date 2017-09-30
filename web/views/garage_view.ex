defmodule EstacionappServer.GarageView do
  use EstacionappServer.Web, :view

  def render("garages_search.json", %{garages: garages}) do
    %{
      garages: render_many(garages, __MODULE__, "garage.json")
    }
  end

  def render("garage.json", %{garage: garage}) do
    %{
      id: garage.id,
      email: garage.email,
      name: garage.name,
      location: render_one(garage.location, __MODULE__, "location.json", as: :location),
      distance: garage.distance,
      pricing: render_one(garage.pricing, __MODULE__, "pricing.json", as: :pricing)
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

  def render("location.json", %{location: location}) do
    {long, lat} = location.coordinates
    [long, lat]
  end
end
