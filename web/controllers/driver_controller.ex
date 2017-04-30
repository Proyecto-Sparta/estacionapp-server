defmodule EstacionappServer.DriverController do
  use EstacionappServer.Web, :controller

  alias EstacionappServer.{Driver, Repo}

  def create(conn, params) do
    %EstacionappServer.Driver{}
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

  def login(conn, params) do
    Repo.get_by(Driver, username: Map.get(params, "username", ""))
      |> case do
        nil -> resp_unauthorized(conn, "invalid login credentials")
        driver -> authenticate(driver, conn)
      end
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
end
