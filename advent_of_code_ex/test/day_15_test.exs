defmodule Day15Test do
  use ExUnit.Case

  @tag timeout: :infinity
  test "works" do
    assert Day15.part1("0,3,6") == 436
    IO.inspect(Day15.part1(), label: "part 1")
    assert Day15.part2("0,3,6") == 175_594
    IO.inspect(Day15.part2(), label: "part 2")
  end
end
