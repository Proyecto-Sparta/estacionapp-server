defmodule EstacionappServer.ReservationController do 
  use EstacionappServer.Web, :controller 
      
  alias EstacionappServer.{Reservation, Params}
 
  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:create] 
  plug Guardian.Plug.LoadResource when action in [:create] 
   
  def create(conn, params) do 
    params = Params.ReservationCreate.validate(params)

    reservation = %Reservation{} 
      |> Reservation.changeset(params)
      |> Repo.insert! 
       
    conn 
      |> put_status(:created) 
      |> json(%{id: reservation.id})       
  end
end
