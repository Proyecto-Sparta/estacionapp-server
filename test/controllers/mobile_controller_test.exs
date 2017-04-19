defmodule EstacionappServer.MobileControllerTest do
  use EstacionappServer.ConnCase

  test "incomplete params on create returns 422 and changeset errors" do
    resp =
      build_conn()
      |> post("/mobile", username: "asd123", full_name: "asd 123")

    assert json_response(resp, 422) == %{"error" => %{"email" => ["can't be blank"]}}
  end
end
