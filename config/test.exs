import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :win_hostname_dns, WinHostnameDnsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LelKaSg2i7G3RzKur2DdImQ3EYw74jMqA0tinxNfuDUwKvcp+lzmjin7hpnVFScQ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
