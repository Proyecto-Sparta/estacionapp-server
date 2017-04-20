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
      # Define common model functionality
      alias EstacionappServer.MongoAdapter
      alias __MODULE__

      use Ecto.Schema
      import Ecto.Changeset

      defp validate_unique(changeset, field, collection) do
        validate_change(changeset, field, fn _, value ->
          case MongoAdapter.count(collection, %{field => value}) do
            {:ok, 0} -> []
            _ -> [{field, "is already taken"}]
          end
        end)
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import EstacionappServer.Router.Helpers
      import EstacionappServer.Gettext
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
