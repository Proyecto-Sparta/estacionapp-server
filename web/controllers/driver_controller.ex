defmodule EstacionappServer.DriverController do
  @moduledoc """
  This is the controller for all API calls related with the drivers client.
  """

  use EstacionappServer.Web, :controller

  alias EstacionappServer.{Driver, Garage, Repo, Utils}

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:search]
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
    driver = %Driver{}
      |> Driver.changeset(params)
      |> Repo.insert!

    conn
      |> put_status(:created)
      |> json(%{id: driver.id})
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
        nil -> raise Error.Unauthorized, message: "Invalid credentials."
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

  defp authenticate(driver, conn) do
    if Guardian.Plug.authenticated?(conn), do: Guardian.Plug.sign_out(conn)
    new_conn = Guardian.Plug.api_sign_in(conn, driver)
    jwt = Guardian.Plug.current_token(new_conn)
    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_status(:accepted)
      |> json(%{status: "logged in"})
  end

  def unauthenticated(_, _), do: raise Error.Unauthorized, message: "Invalid credentials."

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
