defmodule EstacionappServer.GarageControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.Garage

  describe "create with errors" do

    test "with incomplete params returns :unprocessable_entity" do
      assert_error_sent :unprocessable_entity, fn ->
        build_conn()
          |> post(garage_path(@endpoint, :create))
      end
    end

    test "incomplete params returns the errors of the changeset" do
      {_, _, resp} = assert_error_sent :unprocessable_entity, fn ->
        build_conn()
          |> post(garage_path(@endpoint, :create))
      end

      assert Poison.decode!(resp) ==  %{"errors" => %{"detail" => %{"email" => ["can't be blank"],
                                        "name" => ["can't be blank"],
                                        "location" => ["can't be blank"],
                                        "password" => ["can't be blank"],
                                        "username" => ["can't be blank"],
                                        "pricing" => ["can't be blank"]}}}
    end
  end

  describe "create" do

    setup _context do
      {:ok, create_params: %{username: "asd123", full_name: "asd 123",
                              email: "asd@asd.com", password: "password",
                              location: [0, 0], outline: [], name: "asd garage",
                              pricing: %{car: 0, bike: 0, pickup: 0},
                              vehicle: %{ plate: "ASD BCD", type: "car"}}}
    end

    test "creates a garage", %{create_params: create_params} do
      build_conn() |> post(garage_path(@endpoint, :create), create_params)
      assert garages_count() == 1
    end

    test "returns :ok and the garage", %{create_params: create_params} do
      response = build_conn() |> post(garage_path(@endpoint, :create), create_params)
      garage = Repo.one(Garage) |> Repo.preload([:amenities, :layouts])
      pricing = garage.pricing
      assert json_response(response, :ok) == %{"id" => garage.id,
                                               "name" => garage.name,
                                               "email" => garage.email,
                                               "location" => [0, 0],
                                               "distance" => nil,
                                               "pricing" => %{
                                                 "id" => pricing.id,
                                                 "car" => pricing.car,
                                                 "bike" => pricing.bike,
                                                 "pickup" => pricing.pickup
                                               },
                                               "layouts" => [],
                                               "outline" => [],
                                               "amenities" => garage.amenities}
    end
  end

  describe "update" do

    test "changes and returns :ok and the garage" do
      token = garage_jwt()
      response = build_conn()
        |> put_req_header("authorization", token)
        |> patch(garage_path(@endpoint, :update, email: "yo@internet.com"))

      assert json_response(response, :ok) |> renders_garage
    end
  end

  describe "login with errors" do

    test "without authorization returns :bad_request" do
      assert_error_sent :bad_request, fn ->
        build_conn()
        |> post(garage_path(@endpoint, :login))
      end
    end

    test "with wrong authorization returns :bad_request" do
      assert_error_sent :bad_request, fn ->
        build_conn()
        |> put_req_header("authorization", "foobar")
        |> post(garage_path(@endpoint, :login))
      end
    end

    test "with invalid authorization returns :unauthorized" do
      assert_error_sent :unauthorized, fn ->
        build_conn()
        |> put_req_header("authorization", "Basic am9zZTpqb3NlMTIz")
        |> post(garage_path(@endpoint, :login))
      end
    end
  end

  describe "login" do

    test "returns :ok and the garage" do
      assert json_response(valid_garage_login(), :ok) |> renders_garage
    end

    test "returns :ok and a garage with a reservation" do
      driver = insert(:driver)
      garage = insert(:garage)
      garage_layout = insert(:garage_layout, garage_id: garage.id)
      [parking_space] = garage_layout.parking_spaces
      reservation = insert(:reservation, garage_layout_id: garage_layout.id, driver_id: driver.id, parking_space_id: parking_space.id, valid: true)
      
      response = build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("garageuser123:password"))
        |> post(garage_path(@endpoint, :login))

      layouts = [
        %{"id" => garage_layout.id, "floor_level" => 1, "parking_spaces" => [
            %{"id" => parking_space.id, "x" => 0.0, "y" => 0.0, "height" =>  10.0, "width" => 15.0, "occupied" =>  true, "shape" => "square", "angle" => 0.0}
          ],
          "reservations" => [
            %{
              "driver" => %{
                "id" => driver.id,
                "email" => driver.email,
                "full_name" => driver.full_name,
                "vehicle" => %{
                  "type" => "car",
                  "plate" => "ELX-RLZ"
                }
              },
              "id" => reservation.id
            }
          ]
        }
      ]

      assert json_response(response, :ok) == %{ "id" => garage.id,
                                                "name" => "Torcuato Parking",
                                                "email" => "tparking@gmail.com",
                                                "distance" => nil,
                                                "location" => [-58.622210, -34.480666],
                                                "pricing" => %{
                                                  "id" => garage.pricing.id,
                                                  "car" => 15,
                                                  "bike" => 23,
                                                  "pickup" => 88
                                                },
                                                "outline" => [
                                                  %{"x" => 0.0, "y" => 0.0},
                                                  %{"x" => 1.0, "y" => 1.0}
                                                ],
                                                "amenities" => [],
                                                "layouts" => layouts
                                              }
    end

    test "returns a jwt token in the header" do
      "Bearer " <> token = garage_jwt()

      assert String.length(token) > 1
    end
  end

  describe "search with errors" do

    test "without jwt returns :unauthorized" do
      assert_error_sent :unauthorized, fn ->
        build_conn()
          |> get(garage_path(@endpoint, :search, latitude: 0, longuitude: 0))
      end
    end

    test "with jwt and missing parameters returns :bad_request" do
      token = garage_jwt()
      assert_error_sent :bad_request, fn ->
        build_conn()
          |> put_req_header("authorization", token)
          |> get(garage_path(@endpoint, :search))
      end
    end
  end

  describe "search" do

    test "with jwt returns :ok and garages" do
      resp = valid_search()
      %{:id => garage_id, :pricing => %{:id => pricing_id}} = Repo.one(Garage)

      garage = %{
        "id" => garage_id,
        "name" => "Torcuato Parking",
        "email" => "tparking@gmail.com",
        "distance" => 0,
        "location" => [-58.622210, -34.480666],
        "pricing" => %{
          "id" => pricing_id,
          "car" => 15,
          "bike" => 23,
          "pickup" => 88
        },
        "outline" => [
          %{"x" => 0.0, "y" => 0.0},
          %{"x" => 1.0, "y" => 1.0}
        ],
        "amenities" => [],
        "layouts" => []
      }

      assert json_response(resp, :ok) == %{"garages" => [garage]}
    end
  end

  defp renders_garage(response) do
    garage = Repo.one(Garage) |> Repo.preload([:amenities, :layouts])
    pricing = garage.pricing

    Map.delete(response, "distance") == %{
      "id" => garage.id,
      "name" => garage.name,
      "email" => garage.email,
      "location" => [-58.622210, -34.480666],
      "pricing" => %{
        "id" => pricing.id,
        "car" => pricing.car,
        "bike" => pricing.bike,
        "pickup" => pricing.pickup
      },
      "outline" => [%{"x" => 0.0, "y" => 0.0}, %{"x" => 1.0, "y" => 1.0}],
      "amenities" => garage.amenities,
      "layouts" => garage.layouts
    }
  end

  defp valid_search do
    token = garage_jwt()
    query_string = Plug.Conn.Query.encode(%{latitude: -34.480666, longitude: -58.622210})
    build_conn()
      |> put_req_header("authorization", token)
      |> get(garage_path(@endpoint, :search) <> "?" <> query_string)
  end

  defp garages_count, do: Repo.aggregate(Garage, :count, :id)
end
