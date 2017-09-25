defmodule EstacionappServer.GarageController do
  @moduledoc """
  This is the controller for all API calls related with the garages client.
  """

  use EstacionappServer.Web, :controller

  alias EstacionappServer.{Garage, Repo, Utils}

  @doc """
  Inserts a new Garage.
  Returns the inserted garage id or a hash with changeset errors.
  Params:{
    location: [lat, long],
    username: string,
    email: string,
    garage_name: string
  }
  """
  def create(conn, params) do
    params = Map.update(params, "location", nil, &Utils.Gis.make_coordinates/1)
    garage = %Garage{}
      |> Garage.changeset(params)
      |> Repo.insert!
      
    conn
      |> put_status(:created)
      |> json(%{id: garage.id})      
  end

  @doc """
  Authenticates a garage.
  Returns the jwt token inside authorization header.
  Params:{
    username: string
  }
  """
  def login(conn, params) do
    params
      |> Garage.authenticate
      |> case do
        nil -> raise Error.Unauthorized, message: "Invalid credentials."
        garage -> authenticate(garage, conn)
      end   
  end  

  defp authenticate(garage, conn) do
    if Guardian.Plug.authenticated?(conn), do: Guardian.Plug.sign_out(conn)
    new_conn = Guardian.Plug.api_sign_in(conn, garage)
    jwt = Guardian.Plug.current_token(new_conn)
    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_status(:accepted)
      |> json(%{status: "logged in"})
  end
end
