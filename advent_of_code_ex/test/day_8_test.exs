defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "day 8" do
    assert Day8.part1() == 1134
    assert Day8.part2() == 1205
  end
end
