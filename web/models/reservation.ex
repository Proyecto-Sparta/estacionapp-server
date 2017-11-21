defmodule EstacionappServer.Reservation do 
  use EstacionappServer.Web, :model 
 
  alias EstacionappServer.{GarageLayout, Driver} 

  schema "reservations" do 
    field :parking_space_id  
    field :valid?, :boolean
    
    belongs_to :driver, Driver 
    belongs_to :garage_layout, GarageLayout
 
    timestamps() 
  end 
 
  def changeset(struct, params \\ %{}) do 
    fields = [:parking_space_id, :valid?, :driver_id, :garage_layout_id]
    struct 
      |> cast(params, fields)
      |> validate_required(fields)
      |> assoc_constraint(:driver)
      |> assoc_constraint(:garage_layout)
  end 

  def preload_valid_reservations do
    [reservations: from(r in Reservation, where: r.valid? == true, preload: :driver)]
  end  
end 
