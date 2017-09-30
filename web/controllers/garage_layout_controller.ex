defmodule EstacionappServer.GarageLayoutController do
  use EstacionappServer.Web, :controller

  alias EstacionappServer.GarageLayout

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__}
  plug Guardian.Plug.LoadResource
  plug :ensure_ownership when action in [:create, :update, :delete]

  def index(conn, _params) do
    current_garage = conn
      |> Guardian.Plug.current_resource
      |> Repo.preload(:layouts)
        
    conn
      |> put_status(:created)
      |> render("index.json", layouts: current_garage.layouts)
  end  

  def create(conn, params) do
    
  end  

  def update(conn, params) do
    conn.assigns.layout
      |> GarageLayout.changeset(params)
      |> Repo.update!

    send_resp(conn, :ok, "")  
  end  

  def delete(conn, params) do

  end 

  defp ensure_ownership(%{params: %{"id" => layout_id}} = conn, _) do
    requested_layout = layout_id
      |> String.to_integer
      |> (& Repo.get!(GarageLayout, &1)).()
    current_garage = Guardian.Plug.current_resource(conn)
    if current_garage.id != requested_layout.garage_id, do: raise Error.NotFound
    assign(conn, :layout, requested_layout)
  end
end
