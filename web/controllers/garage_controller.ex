defmodule EstacionappServer.GarageController do
  @moduledoc """
  This is the controller for all API calls related with the garages client.
  """

  use EstacionappServer.Web, :controller

  alias EstacionappServer.{Garage, Repo, Utils}

  plug :login_params when var!(action) in [:login]

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
    %Garage{}
      |> Garage.changeset(params)
      |> Repo.insert
      |> case do
        {:ok, garage} ->
          conn
            |> put_status(:created)
            |> json(%{id: garage.id})

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
      |> Garage.authenticate
      |> case do
        nil -> resp_unauthorized(conn, "invalid login credentials")
        garage -> authenticate(garage, conn)
      end
  end

  defp login_params(conn, _) do
    try do
      [user, pass] = conn
        |> get_req_header("authorization")
        |> List.first
        |> String.slice(6..-1)
        |> Base.decode64!
        |> String.split(":")
      Map.put(conn, :params, %{"username" => user, "password" => Cipher.encrypt(pass)})
    rescue
      _ -> raise EstacionappServer.LoginAuthError
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

  def unauthenticated(conn, _params), do: resp_unauthorized(conn, "login needed")

  defp resp_unauthorized(conn, message) do
    conn
      |> put_status(:unauthorized)
      |> json(%{status: message})
  end
end
