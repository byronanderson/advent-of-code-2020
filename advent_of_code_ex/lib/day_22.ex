defmodule Day22 do
  @input File.read!(__DIR__ <> "/day_22_input.txt")

  def part1(text \\ @input) do
    decks = parse(text)
    play(decks) |> elem(1)
  end

  def part2(text \\ @input) do
    decks = parse(text)
    play_2(decks) |> elem(1)
  end

  defp play(%{player_1_deck: deck, player_2_deck: []}), do: {:player1, count_score(deck)}
  defp play(%{player_1_deck: [], player_2_deck: deck}), do: {:player2, count_score(deck)}

  defp play(%{
         player_1_deck: [player_1_card | player_1_deck],
         player_2_deck: [player_2_card | player_2_deck]
       }) do
    if player_1_card > player_2_card do
      play(%{
        player_1_deck: player_1_deck ++ [player_1_card, player_2_card],
        player_2_deck: player_2_deck
      })
    else
      play(%{
        player_1_deck: player_1_deck,
        player_2_deck: player_2_deck ++ [player_2_card, player_1_card]
      })
    end
  end

  defp play_2(deck) do
    play_2(deck, MapSet.new())
  end

  defp play_2(%{player_1_deck: deck, player_2_deck: []}, _), do: {:player1, count_score(deck)}
  defp play_2(%{player_1_deck: [], player_2_deck: deck}, _), do: {:player2, count_score(deck)}

  defp play_2(
         %{
           player_1_deck: [player_1_card | player_1_deck],
           player_2_deck: [player_2_card | player_2_deck]
         } = decks,
         acc
       )
       when length(player_1_deck) >= player_1_card and length(player_2_deck) >= player_2_card do
    case play_2(
           %{
             player_1_deck: player_1_deck |> Enum.take(player_1_card),
             player_2_deck: player_2_deck |> Enum.take(player_2_card)
           },
           acc
         ) do
      {:player1, _} ->
        play_2(
          %{
            player_1_deck: player_1_deck ++ [player_1_card, player_2_card],
            player_2_deck: player_2_deck
          },
          acc
        )

      {:player2, _} ->
        play_2(
          %{
            player_1_deck: player_1_deck,
            player_2_deck: player_2_deck ++ [player_2_card, player_1_card]
          },
          acc
        )
    end
  end

  defp play_2(
         %{
           player_1_deck: [player_1_card | player_1_deck],
           player_2_deck: [player_2_card | player_2_deck]
         } = decks,
         acc
       ) do
    with false <- MapSet.member?(acc, decks),
         acc = MapSet.put(acc, decks) do
      if player_1_card > player_2_card do
        play_2(
          %{
            player_1_deck: player_1_deck ++ [player_1_card, player_2_card],
            player_2_deck: player_2_deck
          },
          acc
        )
      else
        play_2(
          %{
            player_1_deck: player_1_deck,
            player_2_deck: player_2_deck ++ [player_2_card, player_1_card]
          },
          acc
        )
      end
    else
      _ -> {:player1, 0}
    end
  end

  defp count_score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {card, index} -> card * index end)
    |> Enum.sum()
  end

  defp parse(text) do
    [_, player_1_deck, player_2_deck] = Regex.run(~r/Player 1:(.*)Player 2:(.*)\z/s, text)
    %{player_1_deck: parse_deck(player_1_deck), player_2_deck: parse_deck(player_2_deck)}
  end

  defp parse_deck(text) do
    text |> String.trim() |> String.split("\n") |> Enum.map(&parse_int!/1)
  end

  defp parse_int!(string) do
    {number, ""} = Integer.parse(string)
    number
  end
end
