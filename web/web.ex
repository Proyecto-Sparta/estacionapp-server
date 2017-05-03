defmodule EstacionappServer.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use EstacionappServer.Web, :controller
      use EstacionappServer.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      alias EstacionappServer.Repo
      alias __MODULE__

    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias EstacionappServer.Repo
      import Ecto
      import Ecto.Query

      import EstacionappServer.Router.Helpers
      import EstacionappServer.Gettext

      defp error_messages(changeset) do
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        end)
      end
      
      defp encode(model) do
        model
          |> Map.update!(:location, &Geo.JSON.encode/1)
          |> Map.get_and_update(:location, fn location -> 
              [long, lat] = location["coordinates"]
              {location, %{"latitude" => lat, "longitude" => long}} 
            end)
          |> elem(1)
          |> Map.delete(:__meta__)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import EstacionappServer.Router.Helpers
      import EstacionappServer.ErrorHelpers
      import EstacionappServer.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias EstacionappServer.Repo
      import Ecto
      import Ecto.Query
      import EstacionappServer.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
