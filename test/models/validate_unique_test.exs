defmodule EstacionappServer.ValidateUnique do
  use EstacionappServer.ModelCase

  defmodule Foo do
    use EstacionappServer.Web, :model

    embedded_schema do
      field :name, :string
    end

    def changeset(params) do
      %Foo{}
      |> cast(params, [:name])
      |> validate_unique(:name, "foos")
    end
  end

  setup do
    dropCollection("foos")
  end

  test "it is valid when the name is unique" do
    changeset = Foo.changeset(%{name: "Tony Hawk"})
    assert changeset.valid?
  end

  test "it is not valid when there is another with the same value" do
    MongoAdapter.insert_one("foos", %{name: "Tony Hawk"})
    changeset = Foo.changeset(%{name: "Tony Hawk"})
    refute changeset.valid?
  end

  test "it displays the errors when invalid" do
    MongoAdapter.insert_one("foos", %{name: "Tony Hawk"})
    changeset = Foo.changeset(%{name: "Tony Hawk"})
    {_, {error, _}} = List.first(changeset.errors)
    assert error == "is already taken"
  end
end
