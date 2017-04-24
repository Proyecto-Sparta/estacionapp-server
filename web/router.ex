defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  end

  scope "/", EstacionappServer do
    pipe_through :api

    get "/status", ServerController, :status

    scope "/mobile" do
      post "/", MobileController, :create
      get "/login", MobileController, :login
      get "/ping", MobileController, :ping
    end
  end
end
