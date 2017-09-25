defmodule EstacionappServer.Driver do
  use EstacionappServer.Web, :model

  schema "drivers" do
    field :username, :string
    field :password, :string
    field :full_name, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:full_name, :username, :email, :password]
    struct
      |> cast(params, fields)
      |> validate_required(fields)
      |> unique_constraint(:username)
      |> validate_length(:username, min: 5)
      |> validate_length(:full_name, min: 5)
      |> validate_format(:email, ~r/\w+@\w+.\w+/)
      |> put_digested_password
  end

  def authenticate(%{"username" => username, "password" => pass}) do
    Driver
      |> where(username: ^username, password: ^pass)
      |> Repo.one
  end
end
