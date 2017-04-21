defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :secure_api do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  end

  scope "/", EstacionappServer do
    pipe_through :api
    get "/status", ServerController, :status
  end

  scope "/mobile", EstacionappServer do
    pipe_through :api
    post "/", MobileController, :create
    get "/login", MobileController, :login

    pipe_through :secure_api
    get "/ping", MobileController, :ping
  end
end
