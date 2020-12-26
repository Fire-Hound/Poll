defmodule PollTest do
  use ExUnit.Case
  doctest Poll

  test "greets the world" do
    assert Poll.hello() == :world
  end
end
