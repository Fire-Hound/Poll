1 - Adding Nostrum to your project
Add it as a mix project dependency and configure /config/config.exs (or any other env configs) appropriately
https://github.com/Kraigie/nostrum#installation
 
↓ - Pick one of the following steps

2a - Getting a quick example going
+ Take one of the examples and place it in your lib folder
+ Start an iex -S mix session and call the start_link/1 function of your supervisor module
https://github.com/Kraigie/nostrum/tree/master/examples

2b - The Application structure
+ Pick one of the Consumer modules from the examples and add it in lib/bot/consumer.ex
+ Define an Application module
# lib/bot/application.ex
defmodule Bot.Application do
  # This module will be your topmost Supervisor
  use Application

  def start(_type, _args) do
    # Add your Consumer and any other supervisable processes to the children list
    children = [Bot.Consumer]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
+ Define your project entry point
# mix.exs
def application do
  [
    mod: {Bot.Application, []},
    extra_applications: [:logger]
  ]
end
+ Run mix run --no-halt

Q - "I started my bot but it does not respond to messages"
+ Make sure your supervision tree is started and that your Consumer is part of it
+ Make sure that your event handler functions of your Consumer have the appropriate event signatures
https://kraigie.github.io/nostrum/Nostrum.Consumer.html#t:event/0