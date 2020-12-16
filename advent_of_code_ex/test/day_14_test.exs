defmodule Day14Test do
  use ExUnit.Case

  test "day 10" do
    assert Day14.part1("""
           mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
           mem[8] = 11
           mem[7] = 101
           mem[8] = 0
           """) == 165

    IO.inspect(Day14.part1(), label: "part 1 answer")

    assert Day14.part2("""
           mask = 000000000000000000000000000000X1001X
           mem[42] = 100
           mask = 00000000000000000000000000000000X0XX
           mem[26] = 1
           """) == 208

    IO.inspect(Day14.part2(), label: "part 2 answer")
  end
end
