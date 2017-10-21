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

      alias EstacionappServer.{Repo, Utils, Error}
      alias __MODULE__

      defp put_digested_password(changeset) do
        if Map.has_key?(changeset.changes, :password) do
          hashed_pass = Utils.Crypto.encrypt(changeset.params["password"])
          put_change(changeset, :password, hashed_pass)
        else
          changeset
        end
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import Ecto
      import Ecto.Query
      import EstacionappServer.Router.Helpers
      import EstacionappServer.Gettext

      alias EstacionappServer.{Repo, Error, Utils}
      alias __MODULE__      

      plug :login_params when var!(action) in [:login]

      defp login_params(conn, _) do
        try do
          [user, pass] = conn
            |> get_req_header("authorization")
            |> List.first
            |> String.slice(6..-1)
            |> Base.decode64!
            |> String.split(":")
          Map.put(conn, :params, %{"username" => user, "password" => pass})
        rescue
          _ -> raise Error.BadRequest, message: "Error trying to authenticate. Check Authorization header."
        end
      end

      def unauthenticated(_, _), do: raise Error.Unauthorized, message: "Invalid credentials."
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      import Ecto.Changeset
      import EstacionappServer.Router.Helpers
      import EstacionappServer.ErrorHelpers
      import EstacionappServer.Gettext
    end
  end

  def params do
    quote do
      use Ecto.Schema
      
      alias EstacionappServer.Error
      alias __MODULE__
    
      import Ecto.Changeset
    
      @primary_key false      

      def validate(struct), do: struct |> permit |> Map.delete(:__struct__)
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

      import Ecto
      import Ecto.Query
      import EstacionappServer.Gettext

      alias EstacionappServer.Repo
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
