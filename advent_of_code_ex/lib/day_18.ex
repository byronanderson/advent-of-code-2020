defmodule Day18 do
  @input File.read!(__DIR__ <> "/day_18_input.txt")

  def part1(text \\ @input) do
    text |> String.trim() |> String.split("\n") |> Enum.map(&eval/1) |> Enum.sum()
  end

  def part2(text \\ @input) do
    text |> String.trim() |> String.split("\n") |> Enum.map(&eval(&1, :part2)) |> Enum.sum()
  end

  def eval(line, part \\ :part1) when is_binary(line) do
    line
    |> tokenize()
    |> parse()
    |> eval(part)
  end

  def eval([x], _part) when is_integer(x), do: x
  def eval(x, _part) when is_integer(x), do: x

  def eval([x, operator, y | rest], :part1) when operator in ["*", "+", "-"] do
    result =
      case operator do
        "*" -> eval(x) * eval(y)
        "+" -> eval(x) + eval(y)
        "-" -> eval(x) - eval(y)
      end

    eval([result | rest])
  end

  def eval([x, operator, y], :part2) do
    case operator do
      "*" -> eval(x, :part2) * eval(y, :part2)
      "+" -> eval(x, :part2) + eval(y, :part2)
      "-" -> eval(x, :part2) - eval(y, :part2)
    end
  end

  def eval(list, :part2) do
    IO.inspect(list)

    case Enum.find_index(list, fn x -> x == "+" end) do
      nil ->
        [first, operator, second | rest] = list

        eval([eval([first, operator, second], :part2) | rest], :part2)

      index ->
        [8, "+", 6, "*", 4]
        [first, "+", second] = Enum.slice(list, (index - 1)..(index + 1))
        result = eval(first, :part2) + eval(second, :part2)

        before =
          if index - 2 >= 0 do
            Enum.slice(list, 0..(index - 2))
          else
            []
          end

        eval(
          before ++
            [result] ++ Enum.slice(list, (index + 2)..(length(list) - 1)),
          :part2
        )
    end
  end

  defp tokenize(line) do
    line
    |> String.replace(" ", "")
    |> String.split("")
    |> Enum.reject(fn string -> string == "" end)
    |> Enum.map(fn string ->
      with {number, ""} <- Integer.parse(string) do
        number
      else
        _ -> string
      end
    end)
  end

  defp parse(line) do
    parse(line, []) |> Enum.reverse()
  end

  defp parse([], acc) do
    acc
  end

  defp parse(["(" | _rest] = line, acc) do
    {block, rest} = consume_block(line)
    parse(rest, [block | acc])
  end

  defp parse([number | rest], acc) when is_integer(number) do
    parse(rest, [number | acc])
  end

  defp parse([operator | rest], acc)
       when operator in ["*", "+", "-"] do
    parse(rest, [operator | acc])
  end

  defp consume_block(["(" | rest]) do
    consume_block(rest, [])
  end

  defp consume_block(tokens, components) do
    case tokens do
      [")" | rest] ->
        {components, rest}

      [] ->
        throw("unexpected end of file, expected to close the block")

      tokens ->
        {component, rest} = consume_component_value(tokens)
        consume_block(rest, components ++ [component])
    end
  end

  defp consume_component_value(["(" | _rest] = tokens) do
    consume_block(tokens)
  end

  defp consume_component_value([value | rest]) do
    {value, rest}
  end
end
