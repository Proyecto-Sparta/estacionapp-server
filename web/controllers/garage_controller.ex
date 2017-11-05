defmodule EstacionappServer.GarageController do
  use EstacionappServer.Web, :controller
     
  alias EstacionappServer.{Garage, Utils}

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:search, :update]
  plug Guardian.Plug.LoadResource when action in [:update]
  plug :sanitize_search_params when action in [:search]
  
  @moduledoc """
  This is the controller for all API calls related with garages.
  """

  @doc """
  Inserts a new Garage.
  Returns the garage or a hash with the changeset errors. 
  """
  def create(conn, params) do
    params = Map.update(params, "location", nil, &Utils.Gis.make_coordinates/1)
    garage = %Garage{}
      |> Garage.changeset(params)
      |> Repo.insert!
      |> Repo.preload([:amenities, :layouts])
      
    conn
      |> put_status(:ok)
      |> render("show.json", garage: garage)      
  end

  @doc """
  Updates an existing garage.
  Returns the updated garage or a hash with the changeset errors.
  """
  def update(conn, params) do
    updated_garage = conn
      |> Guardian.Plug.current_resource
      |> Garage.changeset(params)
      |> Repo.update!
      |> Repo.preload([:amenities, :layouts])
      
    conn
      |> put_status(:ok)
      |> render("show.json", garage: updated_garage)      
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
      |> Repo.preload([:amenities, :layouts])   

    render(conn, "search.json", garages: garages)
  end

  @doc """
  Authenticates a garage.
  Returns the jwt token inside authorization header and the logged in garage.
  Header authorization must contain `Basic ${username}:${password}` hashed in B64
  """
  def login(conn, params) do
    garage = Garage.from_credentials(params)
    
    conn
      |> put_authorization(garage)
      |> render("show.json", garage:  Repo.preload(garage, [:amenities, :layouts]))
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
