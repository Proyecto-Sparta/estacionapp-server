defmodule EstacionappServer.Utils.Gis do
  @moduledoc """
  Module that gathers all GIS related utils
  """

  defmacro st_distance_spheroid(geometryA, geometryB) do
    quote do: fragment("ST_Distance(?, ?, true)::INTEGER", unquote(geometryA), unquote(geometryB))
  end

  @doc """ 
  Returns a Geo.Point given an array of 2 elements (lat, long)
  """
  def make_coordinates([lat, long]), do: %Geo.Point{coordinates: {long, lat}, srid: 4326}
  def make_coordinates(_), do: nil
end