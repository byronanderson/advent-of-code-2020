defmodule Day23Test do
  use ExUnit.Case

  test "works" do
    assert Day23.part1([3, 8, 9, 1, 2, 5, 4, 6, 7]) == [6, 7, 3, 8, 4, 5, 2, 9]

    IO.inspect(Day23.part1(), label: "part 1")

    # assert Day23.part2([3, 8, 9, 1, 2, 5, 4, 6, 7]) == 149_245_887_792

    # assert Day23.part2() == 0

    IO.inspect(Day23.part2(), label: "part 2")
  end
end
