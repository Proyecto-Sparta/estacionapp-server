defmodule EstacionappServer.GarageLayoutController do
  use EstacionappServer.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__}
  plug Guardian.Plug.LoadResource

  def index(conn, params) do
    current_garage = conn
      |> Guardian.Plug.current_resource
      |> Repo.preload(:layouts)
        
    render(conn, "index.json", layouts: current_garage.layouts)
  end  

  def create(conn, params) do
  end  

  def update(conn, params) do
  end  

  def delete(conn, params) do

  end 
end
