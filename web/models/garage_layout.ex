defmodule EstacionappServer.GarageLayout do
  use EstacionappServer.Web, :model

  alias EstacionappServer.Garage

  schema "garage_layouts" do
    field :floor_level, :integer
    field :parking_spaces, Geo.GeometryCollection
    belongs_to :garage, Garage

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:floor_level, :parking_spaces]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> assoc_constraint(:garage, required: true)
  end
end
