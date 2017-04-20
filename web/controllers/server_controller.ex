defmodule EstacionappServer.ServerController do
  use EstacionappServer.Web, :controller

  def status(conn, _params) do
    json(conn, %{status: "on"})
  end
end
