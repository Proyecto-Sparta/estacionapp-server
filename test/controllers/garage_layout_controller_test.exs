defmodule EstacionappServer.GarageLayoutControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.{Repo, Garage, GarageLayout}

  setup do
    {:ok, token: garage_jwt()}
  end

  test "index returns all layouts of the current garage", jwt do
    driver = insert(:driver)
    garage = Repo.one(Garage)
    %{:id => garage_layout_id, :parking_spaces => [space]} = insert(:garage_layout, garage_id: garage.id)
    reservation = insert(:reservation, garage_layout_id: garage_layout_id, driver_id: driver.id, parking_space_id: space.id, valid: true)


    response = build_conn()
      |> put_req_header("authorization", jwt.token)
      |> get(garage_layout_path(@endpoint, :index))

    layouts = [
      %{"id" => garage_layout_id, "floor_level" => 1, "parking_spaces" => [
          %{"id" => space.id, "x" => 0.0, "y" => 0.0, "height" =>  10.0, "width" => 15.0, "occupied" =>  true, "shape" => "square", "angle" => 0.0}
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
            "id" => reservation.id,
            "parking_space_id" => space.id
          }
        ]
      }
    ]

    assert json_response(response, :ok) == %{"layouts" => layouts}
  end

  test "index returns unauthorized if jwt is invalid or not given" do
    assert_error_sent :unauthorized, fn ->
      build_conn()
        |> get(garage_layout_path(@endpoint, :index))
    end
  end

  test "update modifies the record and returns :ok", jwt do
    garage = Repo.one(Garage)
    layout = insert(:garage_layout, garage_id: garage.id)

    update_response = build_conn()
      |> put_req_header("authorization", jwt.token)
      |> patch(garage_layout_path(@endpoint, :update, layout.id), floor_level: 10)

    modified_layout = Repo.one(GarageLayout)
    assert modified_layout.floor_level == 10
    assert response(update_response, 200) =~ ""
  end

  test "update with a non_existant id fails with :not_found", jwt do
    assert_error_sent :not_found, fn ->
      build_conn()
        |> put_req_header("authorization", jwt.token)
        |> patch(garage_layout_path(@endpoint, :update, 2))
    end
  end

  test "update on a foraneous layout fails with :not_found", jwt do
    garage = Repo.one(Garage)
    insert(:garage_layout, garage_id: garage.id)

    assert_error_sent :not_found, fn ->
      build_conn()
        |> put_req_header("authorization", jwt.token)
        |> patch(garage_layout_path(@endpoint, :update, 5000))
    end
  end

  test "create with wrong params returns :unprocessable_entity", jwt do
    assert_error_sent :unprocessable_entity, fn ->
      build_conn()
        |> put_req_header("authorization", jwt.token)
        |> post(garage_layout_path(@endpoint, :create))
    end
  end

  test "create with wrong params returns changeset errors", jwt do

    {_, _, response} = assert_error_sent :unprocessable_entity, fn ->
      build_conn()
        |> put_req_header("authorization", jwt.token)
        |> post(garage_layout_path(@endpoint, :create))
    end

    assert Poison.decode!(response) ==  %{"errors" =>
                                          %{"detail" => %{
                                              "floor_level" => ["can't be blank"],
                                              "garage_id" => ["can't be blank"],
                                              "parking_spaces" => ["can't be blank"]}
                                          }
                                        }
  end

  test "create without authorization fails with :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() |> post(garage_layout_path(@endpoint, :create))
    end
  end

  test "delete with wrong params returns changeset errors", jwt do
    garage = Repo.one(Garage)
    layout = insert(:garage_layout, garage_id: garage.id)

    delete_reponse = build_conn()
      |> put_req_header("authorization", jwt.token)
      |> delete(garage_layout_path(@endpoint, :delete, layout.id))

    assert response(delete_reponse, 200) =~ ""
    assert Repo.aggregate(GarageLayout, :count, :id) == 0
  end

  test "delete on aforaneous layout fails with :not_found", jwt do
    garage = Repo.one(Garage)
    insert(:garage_layout, garage_id: garage.id)

    assert_error_sent :not_found, fn ->
      build_conn()
        |> put_req_header("authorization", jwt.token)
        |> delete(garage_layout_path(@endpoint, :delete, -10))
    end
  end

  test "delete without authorization fails with :unauthorized" do
    assert_error_sent :unauthorized, fn ->
      build_conn() |> delete(garage_layout_path(@endpoint, :delete, 1))
    end
  end
end
