defmodule EstacionappServer.ReservationController do 
  use EstacionappServer.Web, :controller 
      
  alias EstacionappServer.{Reservation, Params}
 
  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:create] 
  plug Guardian.Plug.LoadResource when action in [:create, :update] 
  plug :ensure_ownership when action in [:update]
   
  def create(conn, params) do 
    params = Params.ReservationCreate.validate(params)

    reservation = %Reservation{valid?: true}
      |> Reservation.changeset(params)
      |> Repo.insert!
      
    conn 
      |> put_status(:ok) 
      |> json(%{id: reservation.id})       
  end

  def update(conn, params) do
    updated_reservation = conn.assigns.reservation
      |> Reservation.changeset(params)
      |> Repo.update!
      |> Repo.preload(:driver)
      
    conn
      |> put_status(:ok)
      |> render("show.json", reservation: updated_reservation)      
  end

  defp ensure_ownership(%{params: %{"id" => reservation_id}} = conn, _) do
    requested_reservation = Repo.get!(Reservation, reservation_id) |> Repo.preload([:garage_layout, :driver])
    current_garage = Guardian.Plug.current_resource(conn)

    if current_garage.id != requested_reservation.garage_layout.garage_id, do: raise Error.NotFound
    assign(conn, :reservation, requested_reservation)
  end
end
