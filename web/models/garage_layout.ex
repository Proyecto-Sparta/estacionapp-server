defmodule EstacionappServer.GarageLayout do
  use EstacionappServer.Web, :model

  alias EstacionappServer.Garage

  schema "garage_layouts" do
    field :floor_level, :integer
    
    embeds_many :parking_spaces, GarageLayout.ParkingSpace
    belongs_to :garage, Garage

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:floor_level, :garage_id]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> cast_embed(:parking_spaces)
      |> assoc_constraint(:garage)
  end

  defmodule ParkingSpace do
    use EstacionappServer.Web, :model
    
    embedded_schema do
      field :lat, :float
      field :long, :float
      field :occupied?, :boolean, default: false
    end
  
    def changeset(struct, params \\ %{}) do
      fields = [:lat, :long, :occupied?]
      struct
        |> cast(params, fields)
    end
  end
end
