defmodule ExampleSupervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [ExampleConsumer]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule ExampleConsumer do
  use Nostrum.Consumer
  require Logger
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    help =
      %Nostrum.Struct.Embed{}
      |> Nostrum.Struct.Embed.put_title("POLL HELP")
      |> Nostrum.Struct.Embed.put_description(
        "Try running:\n\n poll \"Are you a socialist?\" \"Yes\" \"No\" "
      )

    cond do
      msg.content == "!sleep" ->
        Api.create_message(msg.channel_id, "Going to sleep...")
        # This won't stop other events from being handled.
        Process.sleep(3000)

      msg.content == "poll" ->
        Api.create_message(msg.channel_id, embed: help)

      String.match?(msg.content, ~r/poll .*/) ->
        map =
          String.split(msg.content, "\"", trim: true)
          |> Enum.drop(1)
          |> Enum.filter(fn str -> !String.match?(str, ~r/^( +)$/) end)
          |> PollUtil.convert_list_to_map()

        IO.inspect(map)

        embed =
          %Nostrum.Struct.Embed{}
          |> Nostrum.Struct.Embed.put_title(map[:question])
          |> PollUtil.put_fields(map[:options])

        {:ok,current} = Api.create_message(msg.channel_id, embed: embed)

        emojis = ["\xF0\x9F\x87\xA6","\xF0\x9F\x87\xA7","\xF0\x9F\x87\xA8","\xF0\x9F\x87\xA9","\xF0\x9F\x87\xAA","\xF0\x9F\x87\xAB","\xF0\x9F\x87\xAC","\xF0\x9F\x87\xAD","\xF0\x9F\x87\xAE","\xF0\x9F\x87\xAF"]
        for i <- 0..length(map[:options])-1, do:  Api.create_reaction(msg.channel_id, current.id, Enum.at(emojis, i))

          # Api.create_reaction(msg.channel_id, current.id, "\xF0\x9F\x85\xB0")


      true ->
        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    IO.puts("default")
    :noop
  end
end

defmodule PollUtil do
  def convert_list_to_map(list) do
    %{question: Enum.at(list, 0), options: Enum.drop(list, 1)}
  end

  def put_fields(embed, list) do
    a = 97

    fields =
      0..(length(list) - 1)
      |> Stream.zip(list)
      |> Enum.into(%{})
      |> Enum.map(fn {key, value} ->
        %Nostrum.Struct.Embed.Field{
          name: ":regional_indicator_#{String.Chars.to_string([a + key])}:",
          value: value,
          inline: true
        }
      end)

    Map.put(embed, :fields, fields)
  end


end
