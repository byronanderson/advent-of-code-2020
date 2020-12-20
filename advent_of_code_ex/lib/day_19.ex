defmodule Day19 do
  @input File.read!(__DIR__ <> "/day_19_input.txt")

  def part1(text \\ @input) do
    data = parse(text)

    data.messages
    |> Enum.count(fn line -> valid?(line, data.rules) end)
  end

  def part2(text \\ @input) do
    data = parse(text)

    data =
      data
      |> Map.put(:rules, %{
        data.rules
        | 8 => %{type: "relative", possibilities: [[42], [42, 8]]},
          11 => %{type: "relative", possibilities: [[42, 31], [42, 11, 31]]}
      })

    data.messages
    |> Enum.count(fn line -> valid?(line, data.rules) end)
  end

  defp valid?(line, rules) do
    with {:ok, results} <- consume(line, rules[0], rules) do
      Enum.member?(results, "")
    else
      result ->
        IO.inspect(result)
        false
        # raise line
    end
  end

  def consume("", _rule, _rules), do: :invalid

  def consume(line, %{type: "literal", value: character}, _rules) do
    case String.starts_with?(line, character) do
      true -> {:ok, [String.slice(line, 1..-1)]}
      false -> :invalid
    end
  end

  # what if they are unbalanced? << now relevant
  def consume(string, %{type: "relative", possibilities: possibilities}, rules) do
    IO.inspect(string)

    Enum.flat_map(possibilities, fn possibility ->
      possibility
      |> Enum.reduce(
        [string],
        fn rule_id, forks ->
          forks
          |> Enum.flat_map(fn fork ->
            case consume(fork, rules[rule_id], rules) do
              {:ok, newforks} -> newforks
              :invalid -> []
            end
          end)
        end
      )
      |> Enum.uniq()
    end)
    |> case do
      [] -> :invalid
      tails -> {:ok, tails}
    end
  end

  def consume(_, _rule, _rules) do
    :invalid
  end

  defp parse(text) do
    [rules_text, messages_text] = text |> String.trim() |> String.split("\n\n")
    rules = rules_text |> String.split("\n") |> Enum.map(&line_to_rule/1)
    %{rules: rules |> Enum.into(%{}), messages: messages_text |> String.split("\n")}
  end

  defp line_to_rule(line) do
    [rule_number_string, definition] = line |> String.split(": ")
    rule_number = parse_int!(rule_number_string)
    {rule_number, parse_definition!(definition)}
  end

  defp parse_definition!("\"a\""), do: %{type: "literal", value: "a"}
  defp parse_definition!("\"b\""), do: %{type: "literal", value: "b"}

  defp parse_definition!(definition) do
    %{
      type: "relative",
      possibilities:
        definition
        |> String.split(" | ")
        |> Enum.map(fn possibility_string ->
          possibility_string |> String.split(" ") |> Enum.map(&parse_int!/1)
        end)
    }
  end

  defp parse_int!(string) do
    {number, ""} = Integer.parse(string)
    number
  end
end
