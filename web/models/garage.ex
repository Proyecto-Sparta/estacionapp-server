defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model

  import Geo.PostGIS
  import EstacionappServer.Utils.Gis

  alias EstacionappServer.{Repo, GarageLayout, Garage, Utils}
  
  schema "garages" do
    field :username
    field :password
    field :name
    field :email
    field :location, Geo.Point

    has_many :layouts, GarageLayout, on_replace: :delete
    embeds_one :pricing, Garage.Pricing

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
      |> put_location
      |> cast_assoc(:layouts)
      |> cast_embed(:pricing)
  end

  defp put_location(changeset) do
    location = changeset
      |> get_change(:location)
      |> Utils.Gis.make_coordinates
    put_change(changeset, :location, location)
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

  def authenticate(%{"username" => username, "password" => pass}) do
    Garage
      |> where(username: ^username, password: ^pass)
      |> Repo.one
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
end
