ExUnit.start

defmodule EstacionappServer.TestHelper do
  use ExUnit.CaseTemplate
    
  using do
    quote do
      use EstacionappServer.ConnCase
      
      def get(path) do
        build_conn() |> get(path)
      end        
    end
  end    
end
