defmodule EstacionappServer.AmenityTest do
  use EstacionappServer.ModelCase

  alias EstacionappServer.Amenity

  describe "changeset" do
    
    test "changeset with valid attributes" do
      changeset = Amenity.changeset(%Amenity{}, %{description: "Lorem ipsum"})
      assert changeset.valid?
    end
  
    test "without description" do
      changeset = Amenity.changeset(%Amenity{})
      refute changeset.valid?
    end
  
    test "description too short" do
      changeset = Amenity.changeset(%Amenity{}, %{description: "Lorm"})
      refute changeset.valid?
    end
  end
end
