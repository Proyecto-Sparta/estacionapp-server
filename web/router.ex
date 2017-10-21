defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
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
    end

    resources "/reservations", ReservationController, only: [:create]
    resources "/layouts", GarageLayoutController, only: [:index, :create, :update, :delete]
  end
end
