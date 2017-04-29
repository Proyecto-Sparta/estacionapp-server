defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model
  alias EstacionappServer.Garage.Location

  @collection "garages"

  embedded_schema do
    field :_id, :binary_id
    field :garage_name, :string
    field :email, :string
    field :username, :string
    embeds_one :location, Location
  end

  def changeset(struct, params \\ %{}) do
    fields = [:garage_name, :email, :username]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> validate_length(:username, min: 5)
      |> validate_unique(:username, @collection)
      |> validate_length(:garage_name, min: 5)
      |> validate_format(:email, ~r/\w+@\w+.\w+/)
      |> cast_embed(:location, with: &Location.changeset/2, required: true)
  end

  def create(params) do
    garage =
      %EstacionappServer.Garage{}
        |> EstacionappServer.Garage.changeset(params)
        |> Ecto.Changeset.apply_changes
        |> Map.delete(:_id)
        |> normalize_location

    MongoAdapter.insert_one!(@collection, garage)
      |> MongoAdapter.encoded_object_id
  end

  defp normalize_location(%{:location => %{:coordinates => coords}} = garage) do
    %{garage | location: %{coordinates: coords, type: "Point"}}
      |> Map.from_struct
  end

  def collection, do: @collection

  def find_one(query) do
    MongoAdapter.find(@collection, query)
      |> Enum.at(0)
  end
end

defmodule EstacionappServer.Garage.Location do
  use EstacionappServer.Web, :model

  @primary_key false

  embedded_schema do
    field :type, :string
    field :coordinates, {:array, :float}
  end

  def changeset(schema, params) do
    fields = [:type, :coordinates]
    schema
      |> cast(params, fields)
      |> validate_required(:coordinates)
      |> validate_length(:coordinates, is: 2)
  end
end
