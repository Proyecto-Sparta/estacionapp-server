defmodule EstacionappServer.Params.ReservationCreate do
  use EstacionappServer.Web, :params

  embedded_schema do
    field :parking_space_id
    field :garage_layout_id, :integer
    field :driver_id, :integer
  end

  def permit(params) do
    fields = [:parking_space_id, :garage_layout_id, :driver_id]
    changeset = %ReservationCreate{}
      |> cast(params, fields)
      |> validate_required(fields)
    unless changeset.valid?, do: raise Error.BadRequest, message: "Bad request params."
    apply_changes(changeset)
  end
end