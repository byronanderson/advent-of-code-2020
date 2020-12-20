defmodule Day16 do
  @input File.read!(__DIR__ <> "/day_16_input.txt")

  def part1(text \\ @input) do
    data = parse(text)

    data.nearby_tickets
    |> List.flatten()
    |> Enum.filter(fn x -> !valid?(x, data.rules) end)
    |> Enum.sum()
  end

  def part2(text \\ @input) do
    data = parse(text)
    # identify(text)
    [
      [
        %{name: "train", ranges: [43..330, 356..969]}
      ],
      [
        %{name: "arrival platform", ranges: [26..500, 521..960]}
      ],
      [
        %{name: "duration", ranges: [25..861, 873..973]}
      ],
      [
        %{name: "route", ranges: [50..525, 551..973]}
      ],
      [
        %{name: "arrival location", ranges: [39..469, 491..955]}
      ],
      [
        %{name: "departure station", ranges: [30..617, 625..957]}
      ],
      [
        %{name: "class", ranges: [49..293, 318..956]}
      ],
      [
        %{name: "price", ranges: [30..446, 465..958]}
      ],
      [
        %{name: "departure location", ranges: [41..598, 605..974]}
      ],
      [
        %{name: "row", ranges: [39..129, 141..972]}
      ],
      [
        %{name: "departure date", ranges: [37..894, 915..956]}
      ],
      [
        %{name: "zone", ranges: [30..155, 179..957]}
      ],
      [
        %{name: "arrival station", ranges: [47..269, 282..949]}
      ],
      [
        %{name: "departure platform", ranges: [29..914, 931..960]}
      ],
      [
        %{name: "seat", ranges: [37..566, 573..953]}
      ],
      [
        %{name: "type", ranges: [32..770, 792..955]}
      ],
      [
        %{name: "departure track", ranges: [39..734, 756..972]}
      ],
      [
        %{name: "arrival track", ranges: [26..681, 703..953]}
      ],
      [
        %{name: "departure time", ranges: [48..54, 70..955]}
      ],
      [%{name: "wagon", ranges: [47..435, 446..961]}]
    ]
    |> Enum.map(fn list -> List.first(list) end)
    |> Enum.zip(data.my_ticket)
    |> Enum.filter(fn {%{name: name}, _} -> String.contains?(name, "departure") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(1, fn x, y -> x * y end)
  end

  def identify(text) do
    data = parse(text)

    valid_tickets =
      data.nearby_tickets
      |> Enum.reject(fn ticket ->
        Enum.any?(ticket, fn value -> !valid?(value, data.rules) end)
      end)

    # rule =
    #   data.rules
    #   |> Enum.at(0)

    # zipped = valid_tickets |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    # zipped
    # |> Enum.with_index()
    # |> Enum.map(fn {values, position} ->
    #   IO.inspect(values)
    #   {position, Enum.all?(values, fn value -> valid?(value, [rule]) end)}
    # end)

    # find_order(valid_tickets, 0, data.rules)

    # Stream.unfold()
    # an ordering is valid if
    # stream(rules) |> Stream.transform(0, fn rule, acc -> stream(rules |> Kernel.--([rule])))
    every_rule_is_valid_at_every_position = Enum.map(data.my_ticket, fn _ -> data.rules end)

    Enum.reduce(valid_tickets, every_rule_is_valid_at_every_position, fn ticket, acc ->
      IO.inspect(acc, label: "acc")

      ticket
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, position}, acc ->
        acc
        |> List.update_at(position, fn valid_rules ->
          Enum.filter(valid_rules, fn rule -> valid?(value, [rule]) end)
        end)
      end)
    end)
  end

  # {:ok, order} | :none
  defp find_order(tickets, offset, []), do: {:ok, []}

  defp find_order(tickets, offset, rules) do
    IO.inspect(offset)

    possible_matches =
      rules
      |> Enum.filter(fn rule ->
        tickets |> Enum.all?(fn ticket -> Enum.at(ticket, offset) |> valid?([rule]) end)
      end)

    IO.inspect(possible_matches)

    possible_matches
    |> Enum.reduce_while(:none, fn possible_match, acc ->
      case find_order(tickets, offset + 1, rules -- [possible_match]) do
        {:ok, order} -> {:halt, {:ok, [possible_match | order]}}
        _ -> {:cont, :none}
      end
    end)

    # zipped = valid_tickets |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    # zipped
    # |> Enum.with_index()
    # |> Enum.map(fn {values, position} ->
    #   IO.inspect(values)
    #   {position, Enum.all?(values, fn value -> valid?(value, [rule]) end)}
    # end)
  end

  # defp create_stream(rules) do
  #   create_stream(rules, [])
  # end

  # defp create_stream([], stream), do: stream
  # defp create_stream(rules, stream) do
  #   Stream.map(stream, fn used_rules, acc ->
  #     {rules -- used_rules, nil}
  #   end)
  # end

  defp valid?(number, rules) do
    Enum.any?(rules, fn rule ->
      rule.ranges
      |> Enum.any?(fn range -> Enum.member?(range, number) end)
    end)
  end

  defp parse(text) do
    [_, rules_text, my_ticket, nearby_tickets] =
      Regex.run(~r/\A(.*)your ticket:(.*)nearby tickets:(.*)\z/s, text)

    %{
      rules:
        rules_text
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(fn line ->
          [name, values] = line |> String.split(": ")

          %{
            name: name,
            ranges:
              values
              |> String.split(" or ")
              |> Enum.map(fn range ->
                [start, finish] = range |> String.split("-") |> Enum.map(&parse_int!/1)
                start..finish
              end)
          }
        end),
      my_ticket: my_ticket |> String.trim() |> String.split(",") |> Enum.map(&parse_int!/1),
      nearby_tickets:
        nearby_tickets
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(fn line -> line |> String.split(",") |> Enum.map(&parse_int!/1) end)
    }
  end

  defp parse_int!(numberstring) do
    {number, ""} = Integer.parse(numberstring)
    number
  end
end
