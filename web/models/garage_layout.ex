defmodule EstacionappServer.GarageLayout do
  use EstacionappServer.Web, :model

  alias EstacionappServer.Garage

  schema "garage_layouts" do
    field :floor_level, :integer

    embeds_many :parking_spaces, GarageLayout.ParkingSpace, on_replace: :delete
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
      |> cast_embed(:parking_spaces, required: true)
      |> cast_assoc(:garage)
      |> assoc_constraint(:garage)
  end

  defmodule ParkingSpace do
    use EstacionappServer.Web, :model

    embedded_schema do
      field :shape
      field :x, :float
      field :y, :float
      field :height, :float
      field :width, :float
      field :angle, :float
      field :occupied, :boolean, default: false
    end

    def changeset(struct, params \\ %{}) do
      fields = [:x, :y, :height, :width, :occupied, :angle, :shape]
      struct
        |> cast(params, fields)
        |> validate_required(fields)
        |> validate_inclusion(:shape, ["square", "circle"])
    end
  end
end
