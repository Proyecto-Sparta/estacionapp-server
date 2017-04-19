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

  setup_all do
    dropCollection("foos")
    {status, _} = MongoAdapter.insert_one("foos", %{name: "Tony Hawk"})
    on_exit(fn -> dropCollection("foos") end)
    status
  end

  test "it is valid when the name is unique" do
    changeset = Foo.changeset(%{name: "Bam Marguera"})
    assert changeset.valid?
  end

  test "it is not valid when there is another with the same value" do
    refute errored_changeset().valid?
  end

  test "it displays the errors when invalid" do
    {_, {error, _}} = errors()
    assert error == "is already taken"
  end

  defp errored_changeset do
    Foo.changeset(%{name: "Tony Hawk"})
  end

  defp errors do
    errored_changeset().errors
    |> List.first
  end
end
