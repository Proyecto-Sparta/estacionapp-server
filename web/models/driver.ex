defmodule EstacionappServer.Driver do
  use EstacionappServer.Web, :model

  schema "drivers" do
    field :full_name, :string
    field :username, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    fields = [:full_name, :username, :email]
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 5)
    |> validate_length(:full_name, min: 5)
    |> validate_format(:email, ~r/\w+@\w+.\w+/)
  end

  def authenticate(%{"username" => username}) do
    Driver
      |> where(username: ^username)
      |> Repo.one
  end
  
  def authenticate(_), do: nil
end
