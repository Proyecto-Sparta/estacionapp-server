defmodule EstacionappServer.AdapterCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up MonboDB.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias EstacionappServer.MongoAdapter

     
    end
  end

end
