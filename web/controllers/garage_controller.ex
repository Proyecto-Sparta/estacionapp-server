defmodule EstacionappServer.GarageController do
  use EstacionappServer.Web, :controller
     
  alias EstacionappServer.{Garage, Repo, Utils}

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:search, :update]
  plug Guardian.Plug.LoadResource when action in [:update]
  plug :sanitize_search_params when action in [:search]
  
  @moduledoc """
  This is the controller for all API calls related with the garages client.
  """

  @doc """
  Inserts a new Garage.
  Returns the inserted garage id or a hash with changeset errors.  
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
  Updates an existing.
  Returns the inserted garage id or a hash with changeset errors.
  """
  def update(conn, %{"id" => garage_id} = params) do
    garage_id = String.to_integer(garage_id)

    current_garage = Guardian.Plug.current_resource(conn)
    
    if current_garage.id != garage_id, do: raise Error.NotFound

    current_garage
      |> Garage.changeset(params)
      |> Repo.update!
      
    send_resp(conn, :ok, "")   
  end

  @doc """
  Searches for garages.
  Returns an array of garages that satisfies the conditions.
  Querystring: /search?
    latitude=#XXX             [Required]
    longitude=YYY             [Required]
    max_distance=ZZZ          [Optional]
  """
  def search(conn, params) do
    garages = params
      |> Garage.close_to   

    render(conn, "search.json", garages: garages)
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

  defp sanitize_search_params(%{:params => params} = conn, _) do
    try do
      %{"latitude" => lat, "longitude" => long} = params
      location = [lat, long]
        |> Enum.map(&Utils.Parse.to_float/1)
        |> Utils.Gis.make_coordinates

      params
        |> Map.update("max_distance", nil, &Utils.Parse.to_float/1)
        |> Map.put("location", location)
        |> (&Map.put(conn, :params, &1)).()
    rescue
      _ -> raise Error.BadRequest, message: "Error parsing search params."
    end
  end
end
