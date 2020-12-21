defmodule Day21Test do
  use ExUnit.Case

  test "works" do
    fixture = """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """

    assert Day21.part1(fixture) == 5

    IO.inspect(Day21.part1(), label: "part 1")

    assert Day21.part2(fixture) == "mxmxvkd,sqjhc,fvjkl"

    IO.inspect(Day21.part2(), label: "part 2")
  end
end
