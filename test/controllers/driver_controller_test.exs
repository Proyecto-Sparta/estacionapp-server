defmodule EstacionappServer.DriverControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.Driver

  test "create with incomplete params returns :unprocessable_entity" do
    assert_error_sent :unprocessable_entity, fn ->
      build_conn() 
        |> post(driver_path(@endpoint, :create))
    end
  end

  test "create with incomplete params returns the errors of the changeset" do
    {_, _, resp} = assert_error_sent :unprocessable_entity, fn ->
      build_conn() 
        |> post(driver_path(@endpoint, :create))
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
      build_conn() 
        |> get(driver_path(@endpoint, :login))
    end       
  end

  test "login with wrong authorization returns :bad_request" do
    assert_error_sent :bad_request, fn ->
      build_conn() 
        |> put_req_header("authorization", "foobar")
        |> get(driver_path(@endpoint, :login))
    end       
  end

  test "login with invalid authorization returns :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() 
        |> put_req_header("authorization", "Basic am9zZTpqb3NlMTIz")
        |> get(driver_path(@endpoint, :login))
    end       
  end

  test "login with valid authorization returns a jwt token in the header" do
    "Bearer " <> token = jwt()

    assert String.length(token) > 1
  end

  test "login with valid authorization returns :accepted" do
    assert json_response(valid_login(), :accepted) == %{"status" => "logged in"}
  end

  defp valid_create, do: build_conn() |> post(driver_path(@endpoint, :create), username: "asd123", full_name: "asd 123", email: "asd@asd.com", password: "password")

  defp valid_login do
    insert(:driver)
    build_conn() 
      |> put_req_header("authorization", "Basic " <> Base.encode64("joValim:password"))
      |> get(driver_path(@endpoint, :login))
  end

  defp last_id, do: Driver |> last |> Repo.one |> Map.get(:id)

  defp drivers_count, do: Repo.aggregate(Driver, :count, :id)

  defp jwt, do: Plug.Conn.get_resp_header(valid_login(), "authorization") |> List.first
end
