defmodule EstacionappServer.MobileController do
  use EstacionappServer.Web, :controller
  alias EstacionappServer.Driver

  plug EstacionappServer.Plugs.Params, Driver when action in [:create]

  def create(_conn, _params) do

  end
end
