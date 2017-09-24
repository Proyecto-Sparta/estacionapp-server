defmodule EstacionappServer.GarageLayout do
  use EstacionappServer.Web, :model

  alias EstacionappServer.Garage

  schema "garage_layouts" do
    field :floor_level, :integer
    belongs_to :garage, Garage

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:floor_level]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> assoc_constraint(:garage)
  end
end
