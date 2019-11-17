defmodule DockexTest do
  use ExUnit.Case
  doctest Dockex

  test "greets the world" do
    assert Dockex.hello() == :world
  end
end
