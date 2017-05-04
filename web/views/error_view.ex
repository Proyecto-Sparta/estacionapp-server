defmodule EstacionappServer.ErrorView do
  use EstacionappServer.Web, :view

  def render("400.json", assigns) do
    %{errors: %{detail: assigns.reason.message}}
  end

  def render("401.json", assigns) do
    %{errors: %{detail: assigns.reason.message}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("422.json", assigns) do
    changeset = assigns.reason.changeset
    %{errors: %{detail: error_messages(changeset)}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  defp error_messages(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
