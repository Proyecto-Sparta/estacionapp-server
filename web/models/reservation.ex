defmodule EstacionappServer.Reservation do 
  use EstacionappServer.Web, :model 
 
  alias EstacionappServer.{GarageLayout, Driver} 

  schema "reservations" do 
    field :parking_space_id 
    field :status, :integer
    
    belongs_to :driver, Driver 
    belongs_to :garage_layout, GarageLayout
 
    timestamps() 
  end 

  def with_initial_status, do: %Reservation{status: 0}
 
  def changeset(struct, params \\ %{}) do 
    fields = [:parking_space_id, :status, :driver_id, :garage_layout_id] 
    struct 
      |> cast(params, fields)
      |> validate_required(fields)      
      |> validate_inclusion(:status, 0..2)
      |> assoc_constraint(:driver)
      |> assoc_constraint(:garage_layout)
    end 
end 
