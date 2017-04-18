defmodule EstacionappServer.MobileControllerTest do
  use EstacionappServer.ConnCase

  test "server is on" do
    resp = get("/status")
    assert json_response(resp, 200) == %{"status" => "on"}
  end
end
