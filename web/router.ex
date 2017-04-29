defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  end

  scope "/", EstacionappServer do
    pipe_through :api

    get "/status", ServerController, :status

    scope "/driver" do
      post "/", DriverController, :create
      get "/login", DriverController, :login
    end

    scope "/garage" do
      post "/", GarageController, :create
      get "/login", GarageController, :login
    end
  end
end
