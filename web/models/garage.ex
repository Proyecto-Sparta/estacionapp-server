defmodule EstacionappServer.Garage do
  use EstacionappServer.Web, :model

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
    struct
    |> cast(params, [:username, :email, :garage_name])
    |> validate_required([:username, :email, :garage_name])
    |> unique_constraint(:username)
  end
end
