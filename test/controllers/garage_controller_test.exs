defmodule EstacionappServer.GarageControllerTest do
  use EstacionappServer.ConnCase
  use EstacionappServer.ModelCase

  alias EstacionappServer.Garage

  setup_all do
    on_exit(fn -> dropCollection(Garage.collection) end)
  end

  setup do
    dropCollection(Garage.collection)
  end

  test "create with incomplete or wrong params returns :unprocessable_entity and changeset errors" do
    resp =
      build_conn()
      |> post("/garage", username: "asd123", garage_name: "medrano 950", location: %{coordinates: []})

    assert json_response(resp, :unprocessable_entity) == %{"error" =>
      %{"email" => ["can't be blank"],
      "location" => %{"coordinates" => ["should have 2 item(s)"]}}}
  end

  test "create with valid params creates a garage" do
    assert json_response(valid_create(), :created)
    assert garages_count() == 1
  end

  test "create returns encoded ObjectId" do
    assert json_response(valid_create(), :created) == %{"_id" => last_id()}
  end

  test "login with wrong parameters returns :unauthorized" do
    resp =
      build_conn()
      |> get("/garage/login")

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
    build_conn() |> get("/garage/login", username: "asd123", email: "asd@asd.com")
  end

  defp valid_create do
    build_conn() |> post("/garage", username: "asd123",
                                    garage_name: "medrano 950",
                                    email: "asd@asd.com",
                                    location: %{coordinates: [0,0]})
  end

  defp garages_count, do: MongoAdapter.count!(Garage.collection, %{})

  defp last_id do
    %{}
      |> Garage.find_one
      |> MongoAdapter.encoded_object_id
  end
end
