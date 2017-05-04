defmodule EstacionappServer.GuardianSerializer do
  alias EstacionappServer.{Garage, Driver, Repo}

  @behaviour Guardian.Serializer

  def for_token(%Garage{:username => username}), do: {:ok, "123:garage:" <> username}
  def for_token(%Driver{:username => username}), do: {:ok, "123:driver:" <> username}
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("123:garage:" <> username), do: {:ok, Repo.get_by(Garage, username: username)}
  def from_token("123:driver:" <> username), do: {:ok, Repo.get_by(Driver, username: username)}
  def from_token(_), do: {:error, "Unknown resource type" }
end
