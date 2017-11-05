defmodule EstacionappServer.DriverControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.Driver

  describe "create with errors" do

    test "with incomplete params returns :unprocessable_entity" do
      assert_error_sent :unprocessable_entity, fn ->
        build_conn()
          |> post(driver_path(@endpoint, :create))
      end
    end

    test "with incomplete params returns the errors of the changeset" do
      {_, _, resp} = assert_error_sent :unprocessable_entity, fn ->
        build_conn()
          |> post(driver_path(@endpoint, :create))
      end

      assert Poison.decode!(resp) ==  %{"errors" => %{"detail" => %{"email" => ["can't be blank"],
                                        "full_name" => ["can't be blank"],
                                        "password" => ["can't be blank"],
                                        "username" => ["can't be blank"],
                                        "vehicle" => ["can't be blank"]}}}
    end
  end

  describe "create" do

    setup _context do
      {:ok, create_params: %{username: "asd123",
                             full_name: "asd 123",
                             email: "asd@asd.com",
                             password: "password",
                             vehicle: %{
                               plate: "ASD BCD", 
                               type: "car"}}}
    end

    test "with valid params creates a driver and returns :ok", %{create_params: create_params} do
      response = build_conn() |> post(driver_path(@endpoint, :create), create_params)

      assert json_response(response, :ok)
      assert drivers_count() == 1
    end

    test "returns ok and the driver", %{create_params: create_params} do
      response = build_conn() |> post(driver_path(@endpoint, :create), create_params)

      assert json_response(response, :ok) |> renders_driver
    end
  end

  describe "errors with login" do

    test "without authorization returns :bad_request" do
      assert_error_sent :bad_request, fn ->
        build_conn()
          |> post(driver_path(@endpoint, :login))
      end
    end

    test "with wrong authorization returns :bad_request" do
      assert_error_sent :bad_request, fn ->
        build_conn()
          |> put_req_header("authorization", "foobar")
          |> post(driver_path(@endpoint, :login))
      end
    end

    test "with invalid authorization returns :unauthorized" do
      assert_error_sent :unauthorized, fn ->
        build_conn()
          |> put_req_header("authorization", "Basic am9zZTpqb3NlMTIz")
          |> post(driver_path(@endpoint, :login))
      end
    end
  end

  describe "login" do

    test "with valid authorization returns a jwt token in the header and driver data" do
      response = valid_login()
      "Bearer " <> token = Plug.Conn.get_resp_header(response, "authorization") |> List.first

      assert String.length(token) > 1
      assert json_response(response, :ok) |> renders_driver
    end

    test "with valid authorization returns :ok" do
      assert json_response(valid_login(), :ok)
    end
  end

  describe "update" do

    test "changes an existing model and returns :ok" do
      token = get_resp_header(valid_login(), "authorization") |> List.first 
      
      response = build_conn()
        |> put_req_header("authorization", token)
        |> patch(driver_path(@endpoint, :update, vehicle: %{plate: "XXX YYY", type: "pickup"}))

      assert json_response(response, :ok) |> renders_driver
    end
  end

  defp valid_login do
    insert(:driver)
    build_conn()
      |> put_req_header("authorization", "Basic " <> Base.encode64("joValim:password"))
      |> post(driver_path(@endpoint, :login))
  end

  defp renders_driver(response) do
    driver = Repo.one(Driver)
    vehicle = driver.vehicle
    response == %{ "id" => driver.id,
                   "full_name" => driver.full_name,
                   "email" => driver.email,
                   "vehicle" => %{
                     "type" => vehicle.type,
                     "plate" => vehicle.plate}}
  end

  defp drivers_count, do: Repo.aggregate(Driver, :count, :id)
end
