defmodule EstacionappServer.DriverView do
  use EstacionappServer.Web, :view

  def render("driver.json", %{driver: driver}) do
    %{
      id: driver.id,
      email: driver.email,
      full_name: driver.full_name,
      vehicle: render_one(driver.vehicle, __MODULE__, "vehicle.json", as: :vehicle)
    }
  end

  def render("vehicle.json", %{vehicle: vehicle}) do
    %{type: vehicle.type, plate: vehicle.plate}
  end
end
