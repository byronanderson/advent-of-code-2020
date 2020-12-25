defmodule Day25Test do
  use ExUnit.Case

  test "works" do
    fixture = """
    17807724
    14897079
    """

    assert Day25.crack_private_loop_size(5_764_801, 7) == 8

    # assert Day25.part1(fixture) == 14_897_079
    IO.inspect(Day25.part1(), label: "part 1")

    # assert Day25.part2(fixture) == 2208
    IO.inspect(Day25.part2(), label: "part 2")
  end
end
