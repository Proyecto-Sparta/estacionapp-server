defmodule EstacionappServer.GarageLayoutControllerTest do
  use EstacionappServer.ConnCase

  alias EstacionappServer.{Repo, Garage}

  test "index returns all layouts of the current garage" do    
    token = garage_jwt() 
    garage = Repo.one(Garage)

    %{:id => id, :parking_spaces => [space]} = insert(:garage_layout, garage_id: garage.id)

    response = build_conn()
      |> put_req_header("authorization", token) 
      |> get(garage_layout_path(@endpoint, :index))

    layouts = [
      %{"id" => id, "floor_level" => 1, "parking_spaces" => [
          %{"id" => space.id, "lat" => 0.0, "long" => 0.0, "occupied?" => false}
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
end
