defmodule MyprojTest do
  use ExUnit.Case
  doctest Myproj

  test "greets the world" do
    assert Myproj.hello() == :world
  end
end
