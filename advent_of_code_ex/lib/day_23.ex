defmodule Day23 do
  def part1(initial_arrangement \\ [9, 7, 4, 6, 1, 8, 3, 5, 2]) do
    arrangement = play_game(initial_arrangement, 100)
    {before_one, [_one | after_one]} = Enum.split_while(arrangement, fn cup -> cup != 1 end)
    after_one ++ before_one
  end

  def part2(initial_arrangement \\ [9, 7, 4, 6, 1, 8, 3, 5, 2]) do
    extras = Enum.to_list(10..1_000_000)
    actual = initial_arrangement ++ extras
    # actual = initial_arrangement
    first_cup = Enum.at(actual, 0)
    {cons, last} = consecutive(actual)

    arrangement =
      Enum.into(cons, %{})
      |> Map.put(last, first_cup)

    {min, max} = Enum.min_max(actual)

    result = play_game2(arrangement, first_cup, 10_000_000, min, max)
    result[1] * result[result[1]]
  end

  def consecutive(list) do
    {list, last} = consecutive(list, [])
    {Enum.reverse(list), last}
  end

  def consecutive([first, second | rest], acc),
    do: consecutive([second | rest], [{first, second} | acc])

  def consecutive([last], acc), do: {acc, last}
  def consecutive([], acc), do: {acc, nil}

  defp inspect_arrangement(arrangement) do
    inspect_arrangement(arrangement, 1, []) |> Enum.reverse() |> IO.inspect()
  end

  defp inspect_arrangement(arrangement, subject, acc) do
    next_value = arrangement[subject]

    if next_value == 1 do
      [next_value | acc]
    else
      inspect_arrangement(arrangement, next_value, [next_value | acc])
    end
  end

  defp play_game2(arrangement, _, iterations, _, _) when iterations == 0, do: arrangement

  defp play_game2(
         arrangement,
         current_cup,
         iterations,
         min,
         max
       ) do
    # if rem(iterations, 1000) == 0 do
    #   IO.inspect(current_cup)
    # end
    # inspect_arrangement(arrangement)

    # set link for current cup to the thing after the asides
    # set the destination link to the aside group
    # set the last aside link to the thing that destination _had_ been pointing at
    # recurse with a new current_cup of whatever the current cup is now pointing to
    aside_group_1 = arrangement[current_cup]
    aside_group_2 = arrangement[aside_group_1]
    aside_group_3 = arrangement[aside_group_2]
    after_aside_group = arrangement[aside_group_3]

    destination_cup =
      find_destination2(
        current_cup,
        arrangement,
        [aside_group_1, aside_group_2, aside_group_3],
        min,
        max
      )

    new_arrangement =
      arrangement
      |> Map.put(current_cup, after_aside_group)
      |> Map.put(aside_group_3, arrangement[destination_cup])
      |> Map.put(destination_cup, aside_group_1)

    play_game2(new_arrangement, new_arrangement[current_cup], iterations - 1, min, max)
  end

  # 1..100
  # current cup: 1
  # pick up 2, 3, 4
  # destination: 100
  # result: 5..100,2,3,4,1
  # current cup: 5
  # pick up 6,7,8
  # destination: 4
  # result: 9..100,2,3,4,6,7,8,1,5
  # current cup: 9
  # pick up 10,11,12
  # destination: 8
  # result: 13..100,2,3,4,6,7,8,10,11,12,1,5,9

  # so the question is:  what comes after the 1???

  defp play_game(cups, iterations) when iterations == 0, do: cups

  defp play_game(
         [current_cup, set_aside_1, set_aside_2, set_aside_3 | rest] = all_cups,
         iterations
       ) do
    {min, max} = Enum.min_max(all_cups)

    destination_cup = find_destination(current_cup, rest, min, max)
    # destination_index = Enum.find_index(rest, fn val -> val == destination_cup)

    {before_destination, [destination_cup | after_destination]} =
      Enum.split_while(rest, fn cup -> cup != destination_cup end)

    new_cups =
      before_destination ++
        [destination_cup, set_aside_1, set_aside_2, set_aside_3] ++
        after_destination ++ [current_cup]

    play_game(new_cups, iterations - 1)
  end

  defp find_destination(maybe_destination, cups, min, max) do
    destination_cup = maybe_destination - 1

    destination_cup =
      if destination_cup < min do
        max
      else
        destination_cup
      end

    if Enum.member?(cups, destination_cup) do
      destination_cup
    else
      find_destination(destination_cup, cups, min, max)
    end
  end

  defp find_destination2(maybe_destination, arrangement, without, min, max) do
    destination_cup = maybe_destination - 1

    destination_cup =
      if destination_cup < min do
        max
      else
        destination_cup
      end

    if Enum.member?(without, destination_cup) do
      find_destination2(destination_cup, arrangement, without, min, max)
    else
      destination_cup
    end
  end
end
