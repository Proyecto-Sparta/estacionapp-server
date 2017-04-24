defmodule EstacionappServer.Plugs.Params do
  import Plug.Conn
  use Phoenix.Controller

  def init(options), do: options

  def call(conn, module) do
    struct = struct(module)
    changeset = module.changeset(struct, conn.params)

    if changeset.valid? do
      assign(conn, :model, Map.merge(struct, changeset.changes))
    else
      conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: error_messages(changeset)})
        |> halt
    end
  end

  defp error_messages(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
