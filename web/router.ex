defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug CORSPlug, expose: ['authorization']
  end

  scope "/api", EstacionappServer do
    pipe_through :api

    scope "/drivers" do
      get "/login", DriverController, :login
      post "/", DriverController, :create
    end
    
    scope "/garages" do
      get "/login", GarageController, :login
      get "/search", GarageController, :search
      post "/", GarageController, :create
      patch "/:id", GarageController, :update
      options "/login", GarageController, :options
    end

    resources "/layouts", GarageLayoutController, only: [:index, :create, :update]
  end
end
