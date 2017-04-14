defmodule EstacionappServer.Router do
  use EstacionappServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EstacionappServer do
    pipe_through :api

    get "/status", MobileController, :greet
  end
end
