defmodule EstacionappServer.DriverControllerTest do
  use EstacionappServer.ConnCase
  use EstacionappServer.ModelCase

  alias EstacionappServer.Driver

  setup_all do
    on_exit(fn -> dropCollection(Driver.collection) end)
  end

  setup do
    dropCollection(Driver.collection)
  end

  test "create with incomplete params returns :unprocessable_entity and changeset errors" do
    resp =
      build_conn()
      |> post("/driver", username: "asd123", full_name: "asd 123")

    assert json_response(resp, :unprocessable_entity) == %{"error" => %{"email" => ["can't be blank"]}}
  end

  test "create with valid params creates a driver" do
    assert json_response(valid_create(), :created)
    assert drivers_count() == 1
  end

  test "create returns encoded ObjectId" do
    assert json_response(valid_create(), :created) == %{"_id" => last_id()}
  end

  test "login with wrong parameters returns :unauthorized" do
    resp =
      build_conn()
      |> get("/driver/login")

    assert json_response(resp, :unauthorized) == %{"status" => "invalid login credentials"}
  end

  test "login with valid params returns a jwt token in the header" do
    header_token = Plug.Conn.get_resp_header(valid_login(), "authorization") |> List.first

    assert String.contains?(header_token, "Bearer ")
  end

  test "login with valid params returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  defp valid_login do
    valid_create()
    build_conn() |> get("/driver/login", username: "asd123", email: "asd@asd.com")
  end

  defp valid_create, do: build_conn() |> post("/driver", username: "asd123", full_name: "asd 123", email: "asd@asd.com")

  defp drivers_count, do: MongoAdapter.count!(Driver.collection, %{})

  defp last_id do
    %{}
      |> Driver.find_one
      |> MongoAdapter.encoded_object_id
  end
end
