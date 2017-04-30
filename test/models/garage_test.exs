defmodule EstacionappServer.GarageTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.Garage

  @valid_attrs %{email: "some content", garage_name: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Garage.changeset(%Garage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Garage.changeset(%Garage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
