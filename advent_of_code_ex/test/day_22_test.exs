defmodule Day22Test do
  use ExUnit.Case

  test "works" do
    fixture = """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """

    assert Day22.part1(fixture) == 306

    IO.inspect(Day22.part1(), label: "part 1")

    assert Day22.part2(fixture) == 291

    assert Day22.part2("""
           Player 1:
           43
           19

           Player 2:
           2
           29
           14
           """) == 0

    IO.inspect(Day22.part2(), label: "part 2")
  end
end
