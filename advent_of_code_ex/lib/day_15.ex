defmodule Day15 do
  @input "2,20,0,4,1,17"
  def part1(text \\ @input) do
    do_it(setup(parse(text), 2020))
  end

  defp parse(text) do
    text
    |> String.split(",")
    |> Enum.map(fn string ->
      {number, ""} = Integer.parse(string)
      number
    end)
  end

  defp do_it({turn, just_said, acc, 0}), do: just_said

  defp do_it({turn, just_said, acc, left}) do
    value =
      case Map.get(acc, just_said) do
        nil -> 0
        last_said_turn -> turn - last_said_turn
      end

    do_it({turn + 1, value, acc |> Map.put(just_said, turn), left - 1})
  end

  defp setup(list, iterations) do
    {number, initial} = List.pop_at(list, -1)

    initial_length = length(initial)

    {initial_length, number, initial |> Enum.with_index() |> Enum.into(%{}),
     iterations - initial_length - 1}
  end

  def part2(text \\ @input) do
    do_it(setup(parse(text), 30_000_000))
  end
end
