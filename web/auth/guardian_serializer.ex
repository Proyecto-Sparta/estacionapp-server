defmodule EstacionappServer.GuardianSerializer do
  alias EstacionappServer.Driver

  @behaviour Guardian.Serializer

  def for_token(%{"username" => username }), do: {:ok, "123:" <> username}
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("123:" <> username), do: {:ok, Driver.find_one(%{username: username})}
  def from_token(_), do: {:error, "Unknown resource type" }
end
