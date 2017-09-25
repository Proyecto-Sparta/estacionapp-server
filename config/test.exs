use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :estacionapp_server, EstacionappServer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :estacionapp_server, EstacionappServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "estacionapp",
  password: "estacionapp",
  database: "estacionapp_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

  config :cipher, keyphrase: "testiekeyphraseforcipher",
    ivphrase: "testieivphraseforcipher",
    magic_token: "magictoken"
