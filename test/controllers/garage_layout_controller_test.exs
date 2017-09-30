defmodule EstacionappServer.GarageLayoutControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.{Repo, Garage, GarageLayout}

  setup do
    {:ok, token: garage_jwt()}
  end

  test "index returns all layouts of the current garage", jwt do
    garage = Repo.one(Garage)

    %{:id => id, :parking_spaces => [space]} = insert(:garage_layout, garage_id: garage.id)

    response = build_conn()
      |> put_req_header("authorization", jwt.token) 
      |> get(garage_layout_path(@endpoint, :index))

    layouts = [
      %{"id" => id, "floor_level" => 1, "parking_spaces" => [
          %{"id" => space.id, "lat" => 0.0, "long" => 0.0, "occupied?" => false}
        ]
      }
    ]
    
    assert json_response(response, :created) == %{"layouts" => layouts}
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
end
