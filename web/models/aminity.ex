defmodule EstacionappServer.Amenity do
  use EstacionappServer.Web, :model

  schema "amenities" do
    field :description

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    fields = [:description]
    struct
      |> cast(params, fields)
      |> validate_required(fields)      
      |> unique_constraint(:description)
      |> validate_length(:description, min: 5)
  end
end
