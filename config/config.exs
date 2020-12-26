use Mix.Config

config :nostrum,
  token: System.get_env("discord-token-poll"), # The token of your bot as a string
  num_shards: :auto, # The number of shards you want to run your bot under, or :auto.
  gateway_intents: [
    :guild_messages
  ]
