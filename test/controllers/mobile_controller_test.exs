defmodule EstacionappServer.MobileControllerTest do
  use EstacionappServer.ConnCase

  test "api is alive!" do
    conn = get("/status")
    assert json_response(conn, 200) == %{"status" => "Engaged"}
  end
end