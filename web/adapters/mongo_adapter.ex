defmodule EstacionappServer.MongoAdapter do
  @moduledoc """
  Mongo adapter for Estacionapp. It proxies all of MongoDB functions to avoid
  passing the pool and pool handler.

  For more info redirect to [ericmj's github'](https://github.com/ericmj/mongodb)
  """

    @pool :estacionapp_pool
    @pool_handler {:pool, DBConnection.Poolboy}

    Mongo.__info__(:functions)
     |> Enum.into(%{})
     |> Map.delete(:child_spec)
     |> Map.delete(:start_link)
     |> Enum.each(fn {name, arity} ->
            case arity do
              5 -> def unquote(name)(f, s , t, opts \\ []), do: Mongo.unquote(name)(@pool, f, s, t, [unquote(@pool_handler) | opts])
              4 -> def unquote(name)(f, s,  opts \\ []), do: Mongo.unquote(name)(@pool, f, s, [unquote(@pool_handler) | opts])
              3 -> def unquote(name)(f, opts \\ []), do: Mongo.unquote(name)(@pool, f, [unquote(@pool_handler) | opts])
              0 -> def unquote(name)(), do: Mongo.unquote(name)
              _ -> raise "Error proxying Mongo function #{name}/#{arity}"
            end
     end)
end
