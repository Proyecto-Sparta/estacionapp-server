defmodule EstacionappServer.GarageControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.{Garage, Endpoint}

  import EstacionappServer.Factory

  test "create with incomplete params returns :unprocessable_entity" do
    assert_error_sent :unprocessable_entity, fn ->
      build_conn() 
        |> post(garage_path(Endpoint, :create))
    end    
  end

  test "create with incomplete params returns the errors of the changeset" do
    {_, _, resp} = assert_error_sent :unprocessable_entity, fn ->
      build_conn() 
        |> post(garage_path(Endpoint, :create))
    end

    assert Poison.decode!(resp) ==  %{"errors" => %{"detail" => %{"email" => ["can't be blank"], 
                                      "name" => ["can't be blank"], 
                                      "location" => ["can't be blank"], 
                                      "password" => ["can't be blank"], 
                                      "username" => ["can't be blank"]}}}
  end

  test "create with valid params creates a garage" do
    assert json_response(valid_create(), :created)
    assert garages_count() == 1
  end

  test "create returns id" do
    assert json_response(valid_create(), :created) == %{"id" => last_id()}
  end

  test "login without authorization returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn() 
      |> get(garage_path(Endpoint, :login))
    end
  end

  test "login with wrong authorization returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn()
        |> put_req_header("authorization", "foobar")
        |> get(garage_path(Endpoint, :login))
    end
  end

  test "login with invalid authorization returns :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() 
        |> put_req_header("authorization", "Basic am9zZTpqb3NlMTIz")
        |> get(garage_path(Endpoint, :login))
    end       
  end

  test "login with valid params returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  test "login with valid params returns a jwt token in the header" do
    "Bearer " <> token = jwt()

    assert String.length(token) > 1
  end

  test "search without jwt returns :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() 
        |> get(garage_path(Endpoint, :search, latitude: 0, longuitude: 0))
    end             
  end

  test "search with jwt and missing parameters returns :bad_request" do
    token = jwt()
    assert_error_sent :bad_request, fn -> 
      build_conn() 
        |> put_req_header("authorization", token)
        |> get(garage_path(Endpoint, :search))
    end             
  end

  test "search with jwt returns :ok and garages" do
    resp = valid_search()      
    %{:id => garage_id, :pricing => %{:id => pricing_id}} = Repo.one(Garage)

    garage = %{      
      "id" => garage_id,
      "name" => "Torcuato Parking",
      "email" => "tparking@gmail.com",
      "location" => [-58.622210, -34.480666],  
      "distance" => 0,    
      "pricing" => %{
        "id" => pricing_id,
        "car" => 0,
        "bike" => 0,
        "pickup" => 0
      }
    }

    assert json_response(resp, :ok) == %{"garages" => [garage]}    
  end

  defp valid_create do
    build_conn()
      |> post(garage_path(Endpoint, :create),
              username: "medranogarage950",
              email: "medranogarage950@gmail.com",
              name: "Medrano 950",
              location: [0,0],
              password: "password")
  end

  defp valid_login do
    insert(:garage)
    build_conn()
      |> put_req_header("authorization", "Basic " <> Base.encode64("garageuser123:password"))
      |> get(garage_path(Endpoint, :login))
  end

  defp valid_search do          
    token = jwt()
    query_string = Plug.Conn.Query.encode(%{latitude: -34.480666, longitude: -58.622210})
    build_conn() 
      |> put_req_header("authorization", token) 
      |> get(garage_path(Endpoint, :search) <> "?" <> query_string)
  end

  defp last_id, do: Garage |> last |> Repo.one |> Map.get(:id)

  defp garages_count, do: Repo.aggregate(Garage, :count, :id)

  defp jwt, do: get_resp_header(valid_login(), "authorization") |> List.first
end
