defmodule EstacionappServer.ServerView do
  use EstacionappServer.Web, :view

  def render("status.json", %{:status => server_status}) do
    %{status: server_status}
  end
end
