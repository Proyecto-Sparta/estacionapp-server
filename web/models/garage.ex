defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model

  import Geo.PostGIS
  import EstacionappServer.Utils.Gis

  alias EstacionappServer.{Repo, GarageLayout}
  
  schema "garages" do
    field :username, :string
    field :password, :string
    field :garage_name, :string
    field :email, :string
    field :location, Geo.Point

    has_many :layouts, GarageLayout

    field :distance, :integer, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:username, :email, :garage_name, :location, :password]
    struct
      |> cast(params, fields)
      |> cast_assoc(:layouts)
      |> validate_required(fields)
      |> unique_constraint(:username)
      |> validate_length(:username, min: 5)
      |> validate_length(:garage_name, min: 5)
      |> validate_length(:password, min: 5)
      |> validate_format(:email, ~r/\w+@\w+.\w+/)
      |> put_digested_password
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
    select: map(garage, [:id, :email, :garage_name, :location]),
    select_merge: %{distance: st_distance_spheroid(^location, garage.location)}
  end
end
