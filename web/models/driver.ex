defmodule EstacionappServer.Driver do
  use EstacionappServer.Web, :model

  @collection "drivers"

  embedded_schema do
    field :_id, :binary_id
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
      |> validate_unique(:username, @collection)
      |> validate_length(:full_name, min: 5)
      |> validate_format(:email, ~r/\w+@\w+.\w+/)
  end

  def create(params) do
    driver =
      %EstacionappServer.Driver{}
        |> EstacionappServer.Driver.changeset(params)
        |> Ecto.Changeset.apply_changes
        |> Map.delete(:_id)

    MongoAdapter.insert_one!(@collection, driver)
      |> MongoAdapter.encoded_object_id
  end

  def collection, do: @collection

  def find_one(query) do
    MongoAdapter.find(@collection, query)
      |> Enum.at(0)
  end
end
