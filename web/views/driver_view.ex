defmodule EstacionappServer.DriverView do
  use EstacionappServer.Web, :view
  
  def render("driver.json", %{driver: driver}) do
    %{
      id: driver.id,
      email: driver.email,
      name: driver.full_name
    }
  end
end
