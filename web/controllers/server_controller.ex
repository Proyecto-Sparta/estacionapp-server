defmodule EstacionappServer.ServerController do
  use EstacionappServer.Web, :controller

  def status(conn, _params) do
    render(conn, "status.json", status: "on")
  end
end
