defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model

  import Geo.PostGIS
  import EstacionappServer.Utils.Gis

  alias EstacionappServer.{Repo, GarageLayout, Garage, Utils, Amenity}

  schema "garages" do
    field :username
    field :password
    field :name
    field :email
    field :location, Geo.Point

    has_many :layouts, GarageLayout, on_replace: :delete
    embeds_one :pricing, Garage.Pricing
    embeds_many :outline, Garage.Outline, on_replace: :delete
    many_to_many :amenities, Amenity, join_through: "garages_amenities", on_replace: :delete

    field :distance, :integer, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:username, :email, :name, :location, :password]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> unique_constraint(:username)
      |> validate_length(:username, min: 5)
      |> validate_length(:name, min: 5)
      |> validate_length(:password, min: 5)
      |> validate_format(:email, ~r/\w+@\w+.\w+/)
      |> put_digested_password
      |> cast_embed(:pricing, required: true)
      |> cast_embed(:outline)
      |> put_amenities(params)
  end

  @doc """
  Searches garages by distance
  """
  def close_to(%{"location" => location} = params) do
    Garage
      |> closer_than(location, params["max_distance"])
      |> select_distance(location)
      |> Repo.all
  end

  defp closer_than(queryable, _, nil), do: queryable

  defp closer_than(queryable, location, distance) do
    from garage in queryable,
      where: st_dwithin_in_meters(garage.location, ^location, ^distance),
      order_by: st_distance_spheroid(^location, garage.location)
  end

  defp select_distance(queryable, location) do
    from garage in queryable,
      select_merge: %{distance: st_distance_spheroid(^location, garage.location)}
  end

  defp put_amenities(changeset, %{"amenities" => amenities}) when is_list(amenities) do
    build_amenities = fn amenity_id -> Repo.get!(Amenity, amenity_id) end
    amenities
      |> Enum.map(build_amenities)
      |> (& put_assoc(changeset, :amenities, &1)).()
  end

  defp put_amenities(changeset, %{amenities: amenities}) when is_list(amenities) do
    build_amenities = fn amenity_id -> Repo.get!(Amenity, amenity_id) end
    amenities
      |> Enum.map(build_amenities)
      |> (& put_assoc(changeset, :amenities, &1)).()
  end

  defp put_amenities(changeset, _), do: changeset

  defmodule Pricing do
    use EstacionappServer.Web, :model

    embedded_schema do
      field :car, :integer, default: 0
      field :bike, :integer, default: 0
      field :pickup, :integer, default: 0
    end

    def changeset(struct, params \\ %{}) do
      fields = [:car, :bike, :pickup]
      struct
        |> cast(params, fields)
        |> validate_number(:car, greater_than_or_equal_to: 0)
        |> validate_number(:bike, greater_than_or_equal_to: 0)
        |> validate_number(:pickup, greater_than_or_equal_to: 0)
    end
  end

  defmodule Outline do
    use EstacionappServer.Web, :model

    embedded_schema do
      field :x, :float
      field :y, :float
    end

    def changeset(struct, params \\ %{}) do
      fields = [:x, :y]
      struct
        |> cast(params, fields)
        |> validate_required(fields)
    end
  end
end
