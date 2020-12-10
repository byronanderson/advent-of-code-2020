defmodule Day10 do
  @input [
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    3,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1,
    3,
    1,
    1,
    3,
    3,
    1,
    1,
    3,
    1,
    1,
    1,
    3,
    1,
    1,
    3,
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    3,
    3,
    3,
    1,
    3,
    3,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1,
    3,
    3,
    3,
    1,
    1,
    1,
    3,
    1,
    1,
    3,
    1,
    3,
    1,
    1,
    1,
    1,
    3,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1,
    1
  ]
  def part2(data \\ @input) do
    Enum.chunk_while(
      data,
      [],
      fn
        1, acc -> {:cont, [1 | acc]}
        3, acc -> {:cont, acc, []}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, acc, []}
      end
    )
    |> Enum.reduce(1, fn
      [], acc ->
        acc

      [1], acc ->
        acc

      # 1,1 or 2 = 2 possibilities
      [1, 1], acc ->
        acc * 2

      # 1,1,1 or 2,1 or 1,2 or 3 = 4 possibilities
      [1, 1, 1], acc ->
        acc * 4

      # 1,1,1,1 or 2,1,1 or 1,2,1 or 1,1,2 or 3,1 or 1,3 or 2,2 = 7 possibilities
      [1, 1, 1, 1], acc ->
        acc * 7
    end)

    # combinations(data)
  end
end
