defmodule Day17Test do
  use ExUnit.Case

  test "works" do
    assert Day17.part1("""
           .#.
           ..#
           ###
           """) == 112

    IO.inspect(Day17.part1(), label: "part 1 answer")

    assert Day17.part2("""
           .#.
           ..#
           ###
           """) == 848

    IO.inspect(Day17.part2(), label: "part 2 answer")
  end
end
