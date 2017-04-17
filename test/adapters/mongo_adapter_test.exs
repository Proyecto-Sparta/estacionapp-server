defmodule EstacionappServer.MongoAdapterTest do
  use EstacionappServer.AdapterCase

  test "commands are proxying and replacing static parameters" do    
    assert MongoAdapter.command!(ping: true) == %{"ok" => 1}
  end
end