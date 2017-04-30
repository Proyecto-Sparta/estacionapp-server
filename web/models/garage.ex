defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model
  alias EstacionappServer.Repo

  schema "garages" do
    field :username, :string
    field :email, :string
    field :garage_name, :string

    field :location, Geo.Point

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

  def authenticate(%{"username" => username}) do
    Garage
      |> where(username: ^username)
      |> Repo.one
  end
  
  def authenticate(_), do: nil
end
