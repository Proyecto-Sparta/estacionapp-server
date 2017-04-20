defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :secure_api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
  end

  scope "/", EstacionappServer do
    pipe_through :api
    get "/status", ServerController, :status
  end

  scope "/mobile", EstacionappServer do
    pipe_through :api
    post "/", MobileController, :create
    get "/login", MobileController, :login
  end
end
