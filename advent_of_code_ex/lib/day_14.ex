defmodule Day14 do
  use Bitwise
  @input File.read!(__DIR__ <> "/day_14_input.txt")
  def part1(text \\ @input) do
    #       let memory: {[key: string]: number} = {};
    # let mask = {and: 2^37 - 1, or: 0};
    # function applyMask(number: number, mask: {and: number, or: number}) {
    #   if (number === 1843) console.log(number | mask.or)
    #   return (number & mask.and) | mask.or;
    # }
    # parse(text).forEach((instruction: Instruction) => {
    #   if (instruction.type === "mask") mask = instruction.value;
    #   if (instruction.type === "assign") memory[instruction.location] = applyMask(instruction.value, mask);
    # });

    # return sum(Object.values(memory));

    parse(text)
    |> Enum.reduce({nil, %{}}, fn
      %{type: :mask, value: mask}, {_oldmask, memory} ->
        {mask, memory}

      %{type: :assign, location: location, value: value}, {mask, memory} ->
        {mask, memory |> Map.put(location, apply_mask(value, mask))}
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  defp parse(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      cond do
        match = Regex.run(~r/^mask = ([X01]+)$/, line) ->
          %{
            type: :mask,
            value: %{
              and: parse_int!(match |> Enum.at(1) |> String.replace("X", "1"), 2),
              or: parse_int!(match |> Enum.at(1) |> String.replace("X", "0"), 2),
              raw: match |> Enum.at(1)
            }
          }

        match = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line) ->
          %{
            type: :assign,
            location: parse_int!(match |> Enum.at(1)),
            value: parse_int!(match |> Enum.at(2))
          }

        true ->
          raise "hell: " <> line
      end
    end)
  end

  def part2(text \\ @input) do
    parse(text)
    |> Enum.reduce({nil, %{}}, fn
      %{type: :mask, value: %{raw: mask}}, {_oldmask, memory} ->
        {mask, memory}

      %{type: :assign, location: location, value: value}, {mask, memory} ->
        result = apply_mask2(location, mask)

        {mask,
         result
         |> Enum.with_index()
         |> Enum.reduce(memory, fn {result, index}, memory ->
           Map.put(memory, result, value)
         end)}
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  defp parse_int!(string, base \\ 10) do
    {number, ""} = Integer.parse(string, base)
    number
  end

  defp apply_mask(number, mask) do
    (number &&& mask.and) ||| mask.or
  end

  # instead: upon finding any Xs, add the value of all combinations of those Xs
  # + 2^n * the non-floating stuff

  # what is the value of those Xs?

  defp apply_mask2(number, mask) do
    case Regex.run(~r/([^X]*)X(.*)/, mask) do
      nil ->
        result = extract_mask(mask)
        [(number &&& result.and) ||| result.or]

      match ->
        [_, prelude, postlude] = match

        result =
          apply_mask2(number, prelude <> "Z" <> postlude) ++
            apply_mask2(number, prelude <> "1" <> postlude)

        result |> length()
        result
    end
  end

  defp extract_mask(maskstring) do
    %{
      and: maskstring |> String.replace("0", "1") |> String.replace("Z", "0") |> parse_int!(2),
      or: maskstring |> String.replace("Z", "0") |> parse_int!(2)
    }

    # and: parse_int!(match |> Enum.at(1) |> String.replace("X", "1"), 2),
    # or: parse_int!(match |> Enum.at(1) |> String.replace("X", "0"), 2),
  end
end
