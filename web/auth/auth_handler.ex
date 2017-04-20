defmodule EstacionappServer.AuthHandler do
  use EstacionappServer.Web, :controller

  def unauthenticated(conn, _params) do
    conn
      |> put_status(:unauthorized)
      |> json(%{auth_error: "Authentication required"})
  end
end
