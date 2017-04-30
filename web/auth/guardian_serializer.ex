defmodule EstacionappServer.GuardianSerializer do
  alias EstacionappServer.{Driver, Repo}

  @behaviour Guardian.Serializer

  def for_token(model) when is_map(model), do: {:ok, "123:" <> Map.get(model, :username)}
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("123:" <> username), do: {:ok, Repo.get_by(Driver, username: username)}
  def from_token(_), do: {:error, "Unknown resource type" }
end
