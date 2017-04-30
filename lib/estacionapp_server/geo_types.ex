Postgrex.Types.define(EstacionappServer.GeoTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(), json: Poison)
