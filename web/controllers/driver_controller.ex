defmodule EstacionappServer.DriverController do
  @moduledoc """
  This is the controller for all API calls related with the drivers client.
  """

  use EstacionappServer.Web, :controller
  alias EstacionappServer.{Driver, Garage, Repo, Utils}

  plug :sanitize_search_params when action in [:search]

  @doc """
  Inserts a new Driver. 
  Returns the inserted driver id or a hash with changeset errors.
  Params:{
    full_name: string,
    username: string,
    email: string    
  }
  """
  def create(conn, params) do
    %Driver{}
      |> Driver.changeset(params)
      |> Repo.insert
      |> case do
        {:ok, driver} ->
          conn
            |> put_status(:created)
            |> json(%{id: driver.id})

        {:error, changeset} ->
          conn
            |> put_status(:unprocessable_entity)
            |> json(error_messages(changeset))
            |> halt
      end
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
      |> Driver.authenticate
      |> case do
        nil -> resp_unauthorized(conn, "invalid login credentials")
        driver -> authenticate(driver, conn)
      end
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
    params
      |> Garage.close_to
      |> Enum.map(&encode/1)
      |> (&json(conn, %{garages: &1})).()
  end

  def unauthenticated(conn, _params), do: resp_unauthorized(conn, "login needed")

  defp resp_unauthorized(conn, message) do
    conn
      |> put_status(:unauthorized)
      |> json(%{status: message})
  end

  defp authenticate(driver, conn) do
    if Guardian.Plug.authenticated?(conn), do: Guardian.Plug.sign_out(conn)
    new_conn = Guardian.Plug.api_sign_in(conn, driver)
    jwt = Guardian.Plug.current_token(new_conn)
    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_status(:accepted)
      |> json(%{status: "logged in"})
  end

  defp sanitize_search_params(%{:params => params} = conn, _) do
    location = params
      |> Map.take(["latitude", "longitude"])
      |> Map.values
      |> Enum.map(&Utils.Parse.to_float/1)
      |> Utils.Gis.make_coordinates    
    
    params
      |> Map.update("max_distance", nil, &Utils.Parse.to_float/1)
      |> Map.put("location", location)
      |> (&Map.put(conn, :params, &1)).()
  end
end
