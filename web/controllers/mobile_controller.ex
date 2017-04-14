defmodule EstacionappServer.MobileController do
  use EstacionappServer.Web, :controller

  def greet(conn, _params) do
    json(conn, %{status: "Engaged"})
  end
end