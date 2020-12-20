defmodule Day18Test do
  use ExUnit.Case

  test "works" do
    assert Day18.eval("2 * 3 + (4 * 5)") == 26
    assert Day18.eval("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
    assert Day18.eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
    assert Day18.eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632

    IO.inspect(Day18.part1(), label: "part 1 answer")

    assert Day18.eval("2 * 3 + (4 * 5)", :part2) == 46
    assert Day18.eval("5 + (8 * 3 + 9 + 3 * 4 * 3)", :part2) == 1445
    assert Day18.eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", :part2) == 669_060
    assert Day18.eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", :part2) == 23340

    IO.inspect(Day18.part2(), label: "part 2 answer")
  end
end
