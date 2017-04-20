defmodule EstacionappServer.MobileController do
  use EstacionappServer.Web, :controller
  alias EstacionappServer.Driver

  plug EstacionappServer.Plugs.Params, Driver when action in [:create]

  def create(conn, params) do
    id = Driver.create(params)
    json(conn, %{_id: id})
  end
end
