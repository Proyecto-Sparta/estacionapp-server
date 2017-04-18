defmodule EstacionappServer.Driver do
  use EstacionappServer.Web, :model

  embedded_schema do
    field :full_name, :string
    field :email, :string
    field :username, :string
  end

  def changeset(struct, params \\ %{}) do
    fields = [:full_name, :email, :username]
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_length(:username, min: 5)
    |> validate_unique(:username, "drivers")
    |> validate_length(:full_name, min: 5)
    |> validate_format(:email, ~r/\w+@\w+.\w+/)
  end
end
