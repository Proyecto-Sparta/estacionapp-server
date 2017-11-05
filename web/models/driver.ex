defmodule EstacionappServer.Driver do
  use EstacionappServer.Web, :model

  schema "drivers" do
    field :username
    field :password
    field :full_name
    field :email
    
    embeds_one :vehicle, Driver.Vehicle, on_replace: :update

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
      |> cast_embed(:vehicle, required: true)
      |> put_digested_password
  end

  defmodule Vehicle do
    use EstacionappServer.Web, :model
    
    embedded_schema do
      field :type
      field :plate
    end
  
    def changeset(struct, params \\ %{}) do
      fields = [:type, :plate]
      struct
        |> cast(params, fields)
        |> validate_required(fields)
        |> validate_inclusion(:type, ["bike", "pickup", "car"])
    end
  end
end
