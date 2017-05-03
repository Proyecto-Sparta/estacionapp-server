defmodule EstacionappServer.Utils.Gis do
  @moduledoc """
  Module that gathers all GIS related utils
  """

  @doc """ 
  Query helper that uses a spheroid model
  """
  defmacro st_distance_spheroid(geometryA, geometryB) do
    quote do: fragment("ST_Distance(?, ?, true)::INTEGER", unquote(geometryA), unquote(geometryB))
  end

  @doc """ 
  Returns a Geo.Point given an array of 2 elements (lat, long)
  """
  @spec make_coordinates([float]) :: Geo.Point.t
  def make_coordinates([lat, long]), do: %Geo.Point{coordinates: {long, lat}, srid: 4326}
  def make_coordinates(_), do: nil
end

defmodule EstacionappServer.Utils.Parse do
  @moduledoc """
  Module that gathers all parsing related utils
  """

  @doc """ 
  Returns a float given a string
  """
  @spec to_float(String.t) :: float
  def to_float(string) do
    {value, _} = Float.parse(string)
    value
  end  
end
