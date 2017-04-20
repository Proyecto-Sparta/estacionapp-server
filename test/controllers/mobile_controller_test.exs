defmodule EstacionappServer.MobileControllerTest do
  use EstacionappServer.ConnCase
  use EstacionappServer.ModelCase

  alias EstacionappServer.Driver

  setup_all do
    on_exit(fn -> dropCollection(Driver.collection) end)
  end

  setup do
    dropCollection(Driver.collection)
  end

  test "incomplete params on create returns 422 and changeset errors" do
    resp =
      build_conn()
      |> post("/mobile", username: "asd123", full_name: "asd 123")

    assert json_response(resp, 422) == %{"error" => %{"email" => ["can't be blank"]}}
  end

  test "valid params on create create a driver" do
    assert json_response(valid_response(), 200)
    assert drivers_count() == 1
  end

  test "create returns encoded ObjectId " do
    assert json_response(valid_response(), 200) == %{"_id" => last_id()}
  end

  defp valid_response, do: build_conn() |> post("/mobile", username: "asd123", full_name: "asd 123", email: "asd@asd.com")

  defp drivers_count, do: MongoAdapter.count!(Driver.collection, %{})

  defp last_id do
    Driver.find_one()
    |> Driver.encoded_object_id
  end
end
