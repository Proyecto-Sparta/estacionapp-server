defmodule EstacionappServer.GarageControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.Garage

  import EstacionappServer.Factory

  test "create with incomplete params returns :unprocessable_entity and changeset errors" do
    resp = build_conn() |> post("/api/garage")

    error = %{"email" => ["can't be blank"],
              "username" => ["can't be blank"],
              "garage_name" => ["can't be blank"],
              "location" => ["can't be blank"],
              "password" => ["can't be blank"]}

    assert json_response(resp, :unprocessable_entity) == error
  end

  test "create with valid params creates a garage" do
    assert json_response(valid_create(), :created)
    assert garages_count() == 1
  end

  test "create returns id" do
    assert json_response(valid_create(), :created) == %{"id" => last_id()}
  end

  test "login without parameters returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn() |> get("/api/garage/login")
    end
  end

  test "login with wrong parameters returns :unauthorized" do
    assert_error_sent :bad_request, fn ->
      build_conn()
        |> put_req_header("authorization", "foobar")
        |> get("/api/garage/login")
    end
  end

  test "login with valid params returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  test "login with valid params returns a jwt token in the header" do
    "Bearer " <> token = jwt()

    assert String.length(token) > 1
  end

  defp valid_create do
    build_conn()
      |> post("/api/garage",
              username: "medranogarage950",
              email: "medranogarage950@gmail.com",
              garage_name: "Medrano 950",
              location: [0,0],
              password: "password")
  end

  defp valid_login do
    insert(:garage)
    build_conn()
      |> put_req_header("authorization", "Basic " <> Base.encode64("garageuser123:password"))
      |> get("api/garage/login")
  end

  defp last_id, do: Garage |> last |> Repo.one |> Map.get(:id)

  defp garages_count, do: Repo.aggregate(Garage, :count, :id)

  defp jwt, do: get_resp_header(valid_login(), "authorization") |> List.first
end
