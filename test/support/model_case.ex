defmodule EstacionappServer.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up MonboDB.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias EstacionappServer.MongoAdapter

      defp dropCollection(name) do
        MongoAdapter.command(drop: name)
        :ok
      end
    end
  end
end
