defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model
  
  alias EstacionappServer.Repo

  import Geo.PostGIS
  import EstacionappServer.Utils.Gis  

  schema "garages" do
    field :username, :string
    field :email, :string
    field :garage_name, :string
    field :location, Geo.Point
    
    field :distance, :integer, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:username, :email, :garage_name, :location]
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 5)
    |> validate_length(:garage_name, min: 5)
    |> validate_format(:email, ~r/\w+@\w+.\w+/)
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

  def authenticate(%{"username" => username}) do
    Garage
      |> where(username: ^username)
      |> Repo.one
  end
  
  def authenticate(_), do: nil

  defp closer_than(queryable, _, nil), do: queryable
  
  defp closer_than(queryable, location, distance) do
    from garage in queryable,
      where: st_dwithin_in_meters(garage.location, ^location, ^distance),
      order_by: st_distance_spheroid(^location, garage.location)
  end

  defp select_distance(queryable, location) do
    from garage in queryable,
      select: %{garage | distance: st_distance_spheroid(^location, garage.location)}
  end
end
