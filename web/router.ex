defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug CORSPlug, expose: ['authorization']
  end

  scope "/api", EstacionappServer do
    pipe_through :api

    scope "/driver" do
      post "/", DriverController, :create
      get "/login", DriverController, :login
    end
    
    scope "/garage" do
      post "/", GarageController, :create
      get "/login", GarageController, :login
      get "/search", GarageController, :search
      options "/login", GarageController, :options
    end
  end
end
