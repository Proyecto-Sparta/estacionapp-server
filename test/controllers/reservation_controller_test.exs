defmodule EstacionappServer.ReservationControllerTest do
  use EstacionappServer.ConnCase
 
  alias EstacionappServer.{Garage, Reservation, Repo}
 
  
  describe "when authorized" do
 
    test "creates a reservation" do
      token = garage_jwt()
      garage = Repo.one(Garage)
      driver = insert(:driver)
      layout = insert(:garage_layout, garage_id: garage.id)
      [parking_space] = layout.parking_spaces
 
      build_conn() 
        |> put_req_header("authorization", token)
        |> post(reservation_path(@endpoint, :create, driver_id: driver.id,
                            garage_layout_id: layout.id, parking_space_id: parking_space.id ))
                            
      assert 1 = Repo.aggregate(Reservation, :count, :id)
    end        

    test "updates a reservation" do
      token = garage_jwt()
      garage = Repo.one(Garage)
      driver = insert(:driver)
      layout = insert(:garage_layout, garage_id: garage.id)
      [parking_space] = layout.parking_spaces
      reservation = insert(:reservation, garage_layout_id: layout.id, parking_space_id: parking_space.id, driver_id: driver.id)
 
      build_conn() 
        |> put_req_header("authorization", token)
        |> patch(reservation_path(@endpoint, :update, reservation.id), valid?: true)
                            
      assert Repo.one(Reservation).valid? == true
    end        
  end
 
 
  describe "when not valid" do
  
    test "fails with :bad_request" do
      token = garage_jwt()
      assert_error_sent :bad_request, fn ->
        build_conn() 
        |> put_req_header("authorization", token)
        |> post(reservation_path(@endpoint, :create))
      end
    end
 
    test "when not authorized fails with :unauthorized" do
      assert_error_sent :unauthorized, fn ->
        build_conn() 
        |> post(reservation_path(@endpoint, :create))
      end
    end
  end  
end
