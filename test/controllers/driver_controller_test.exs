defmodule EstacionappServer.DriverControllerTest do
  use EstacionappServer.ConnCase

  import EstacionappServer.Factory  

  alias EstacionappServer.{Driver, Garage}

  test "create with incomplete params returns :unprocessable_entity" do
    assert_error_sent :unprocessable_entity, fn ->
      build_conn() |> post("/api/driver")
    end
  end

  test "create with incomplete params returns the errors of the changeset" do
    {_, _, resp} = assert_error_sent :unprocessable_entity, fn ->
      build_conn() |> post("/api/driver")
    end

    assert Poison.decode!(resp) ==  %{"errors" => %{"detail" => %{"email" => ["can't be blank"], 
                                      "full_name" => ["can't be blank"],                                       
                                      "password" => ["can't be blank"], 
                                      "username" => ["can't be blank"]}}}
  end

  test "create with valid params creates a driver" do
    assert json_response(valid_create(), :created)
    assert drivers_count() == 1
  end

  test "create returns id" do
    assert json_response(valid_create(), :created) == %{"id" => last_id()}
  end

  test "login without authorization returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn() |> get("/api/driver/login")
    end       
  end

  test "login with wrong authorization returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn() 
        |> put_req_header("authorization", "foobar")
        |> get("/api/driver/login")
    end       
  end

  test "login with invalid authorization returns :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() 
        |> put_req_header("authorization", "Basic am9zZTpqb3NlMTIz")
        |> get("/api/driver/login")
    end       
  end

  test "login with valid authorization returns a jwt token in the header" do
    "Bearer " <> token = jwt()

    assert String.length(token) > 1
  end

  test "login with valid authorization returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  test "search without jwt returns :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() |> get("/api/driver/search?latitude=0&longitude=0")
    end             
  end

  test "search with jwt and missing parameters returns :bad_request" do
    assert_error_sent :bad_request, fn -> 
      build_conn() 
        |> put_req_header("authorization", jwt()) 
        |> get("/api/driver/search")
    end             
  end

  test "search with jwt returns :ok and garages" do
    resp = valid_search()        
    garage = %{"username" => "garageuser123",
               "id" => Garage |> last |> Repo.one |> Map.get(:id), 
               "garage_name" => "Torcuato Parking",
               "email" => "tparking@gmail.com",
               "location" => %{"latitude" => -34.480666, "longitude" => -58.622210},
               "distance" => 0}

    assert json_response(resp, :ok) == %{"garages" => [garage]}    
  end

  defp valid_create, do: build_conn() |> post("/api/driver", username: "asd123", full_name: "asd 123", email: "asd@asd.com", password: "password")

  defp valid_login do
    insert(:driver)
    build_conn() 
      |> put_req_header("authorization", "Basic " <> Base.encode64("joValim:password"))
      |> get("api/driver/login")
  end

  defp last_id, do: Driver |> last |> Repo.one |> Map.get(:id)

  defp drivers_count, do: Repo.aggregate(Driver, :count, :id)

  defp jwt, do: Plug.Conn.get_resp_header(valid_login(), "authorization") |> List.first

  defp valid_search do
    insert(:garage)        
    query_string = Plug.Conn.Query.encode(%{latitude: -34.480666, longitude: -58.622210})
    build_conn() 
      |> put_req_header("authorization", jwt()) 
      |> get("/api/driver/search?" <> query_string)
  end
end
