defmodule EstacionappServer.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(_), do: { :ok, "123" }
  def from_token(_), do: { :ok, "123" }
end
