defmodule EstacionappServer.DriverController do
  use EstacionappServer.Web, :controller

  alias EstacionappServer.{Driver, Repo}

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:update]
  plug Guardian.Plug.LoadResource when action in [:update]

  @moduledoc """
  This is the controller for all API calls related with the drivers client.
  """

  def update(conn, params) do
    updated = conn    
      |> Guardian.Plug.current_resource
      |> Driver.changeset(params)
      |> Repo.update!

    conn
      |> put_status(:ok)
      |> render("driver.json", driver: updated)
  end

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
      |> put_status(:ok)
      |> render("driver.json", driver: driver)
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
      |> authenticate(conn)
  end

  defp authenticate(nil, _), do: raise Error.Unauthorized, message: "Invalid credentials."

  defp authenticate(driver, conn) do
    if Guardian.Plug.authenticated?(conn), do: Guardian.Plug.sign_out(conn)
    new_conn = Guardian.Plug.api_sign_in(conn, driver)
    jwt = Guardian.Plug.current_token(new_conn)
    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_status(:ok)
      |> render("driver.json", driver: driver)
  end
end
