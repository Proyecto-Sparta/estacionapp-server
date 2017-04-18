defmodule EstacionappServer.ServerViewTest do
  use EstacionappServer.ConnCase, async: true

  import Phoenix.View

  test "renders status.json" do
    assert render(EstacionappServer.ServerView, "status.json", status: "foo") ==
           %{status: "foo"}
  end
end
