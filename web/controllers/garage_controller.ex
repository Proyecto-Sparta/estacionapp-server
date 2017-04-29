defmodule EstacionappServer.GarageController do
  use EstacionappServer.Web, :controller
  alias EstacionappServer.Garage

  plug EstacionappServer.Plugs.Params, Garage when action in [:create]

  def create(conn, params) do
    id = Garage.create(params)
    conn
      |> put_status(:created)
      |> json(%{_id: id})
  end

  def login(conn, params) do
    default_params = %{"username" => nil, "email" => nil}
    params
      |> Map.take(["username", "email"])
      |> Map.merge(default_params, fn _key, value, default_value -> default_value || value end)
      |> Garage.find_one
      |> case do
        nil -> resp_unauthorized(conn, "invalid login credentials")
        garage -> authenticate(garage, conn)
      end
  end

  def unauthenticated(conn, _params), do: resp_unauthorized(conn, "login needed")

  defp resp_unauthorized(conn, message) do
    conn
      |> put_status(:unauthorized)
      |> json(%{status: message})
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
