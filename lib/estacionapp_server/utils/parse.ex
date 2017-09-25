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
