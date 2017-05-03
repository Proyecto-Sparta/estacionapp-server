defmodule EstacionappServer.DriverControllerTest do
  use EstacionappServer.ConnCase  

  import EstacionappServer.Factory  

  alias EstacionappServer.Driver

  test "create with incomplete params returns :unprocessable_entity and changeset errors" do
    resp = build_conn() |> post("/api/driver", username: "asd123", full_name: "asd 123")

    assert json_response(resp, :unprocessable_entity) == %{"email" => ["can't be blank"]}
  end

  test "create with valid params creates a driver" do
    assert json_response(valid_create(), :created)
    assert drivers_count() == 1
  end

  test "create returns id" do
    assert json_response(valid_create(), :created) == %{"id" => last_id()}
  end

  test "login with wrong parameters returns :unauthorized" do
    resp = build_conn() |> get("/api/driver/login")

    assert json_response(resp, :unauthorized) == %{"status" => "invalid login credentials"}
  end

  test "login with valid params returns a jwt token in the header" do
    "Bearer " <> token = jwt()

    assert String.length(token) > 1
  end

  test "login with valid params returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  test "search without authorization returns :unauthorized" do
    resp = build_conn() |> get("/api/driver/search")

    assert json_response(resp, :unauthorized) == %{"status" => "login needed"}
  end

  test "search with authorization returns :ok and garages" do
    assert json_response(valid_search(), :ok) == %{"garages" => []}    
  end

  defp valid_create, do: build_conn() |> post("/api/driver", username: "asd123", full_name: "asd 123", email: "asd@asd.com")

  defp valid_login do
    insert(:driver)
    build_conn() |> get("api/driver/login", username: "joValim")
  end

  defp last_id, do: Driver |> last |> Repo.one |> Map.get(:id)

  defp drivers_count, do: Repo.aggregate(Driver, :count, :id)

  defp jwt, do: Plug.Conn.get_resp_header(valid_login(), "authorization") |> List.first

  defp valid_search do
    query_string = Plug.Conn.Query.encode(%{latitude: 0, longitude: 0})
    build_conn() 
      |> put_req_header("authorization", jwt()) 
      |> get("/api/driver/search?" <> query_string)
  end
end
