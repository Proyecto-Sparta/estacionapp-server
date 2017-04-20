defmodule EstacionappServer.MobileController do
  use EstacionappServer.Web, :controller
  alias EstacionappServer.Driver

  plug EstacionappServer.Plugs.Params, Driver when action in [:create]

  def create(conn, params) do
    id = Driver.create(params)
    conn
      |> put_status(:created)
      |> json(%{_id: id})
  end

  def login(conn, params) do
    default_params = %{"username" => nil, "email" => nil}
    params
      |> Map.take(["username", "email"])
      |> Map.merge(default_params, fn _key, value, default_value -> default_value || value end)
      |> Driver.find_one
      |> authenticate(conn)
  end

  def authenticate(nil, conn) do
    conn
      |> put_status(:unauthorized)
      |> json(%{status: "invalid login credentials"})
  end

  def authenticate(driver, conn) do
    new_conn = Guardian.Plug.api_sign_in(conn, driver)
    jwt = Guardian.Plug.current_token(new_conn)

    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_status(:accepted)
      |> json(%{status: "logged in"})
  end
end
