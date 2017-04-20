defmodule EstacionappServer.ServerControllerTest do
  use EstacionappServer.ConnCase

  test "server is on" do
    resp =
      build_conn()
      |> get("/status")

    assert json_response(resp, :ok) == %{"status" => "on"}
  end
end
