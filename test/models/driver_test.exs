defmodule EstacionappServer.DriverTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.Driver

  @valid_attrs %{email: "someemail@gmail.com", full_name: "some content", username: "some content", password: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Driver.changeset(%Driver{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Driver.changeset(%Driver{}, @invalid_attrs)
    refute changeset.valid?
  end
end
