defmodule Day24 do
  @input File.read!(__DIR__ <> "/day_24_input.txt")

  def part1(text \\ @input) do
    text
    |> initial_conditions()
    |> MapSet.size()
  end

  def part2(text \\ @input) do
    conditions = initial_conditions(text)

    evolve(conditions, 100)
    |> MapSet.size()
  end

  defp evolve(conditions, iterations) when iterations == 0, do: conditions

  defp evolve(conditions, iterations) do
    all_tiles_adjacent_to_a_black_tile(conditions)
    |> Enum.map(fn location ->
      {
        location,
        if(MapSet.member?(conditions, location), do: :black, else: :white),
        count_adjacent_black(location, conditions)
      }
    end)
    |> Enum.reduce(conditions, fn
      {location, :white, 2}, new_conditions ->
        MapSet.put(new_conditions, location)

      {location, :black, adjacent_black_tiles}, new_conditions
      when adjacent_black_tiles not in [1, 2] ->
        MapSet.delete(new_conditions, location)

      _, new_conditions ->
        new_conditions
    end)
    |> evolve(iterations - 1)
  end

  def all_tiles_adjacent_to_a_black_tile(black_tile_locations) do
    black_tile_locations
    |> Enum.flat_map(fn location -> [location] ++ adjacent_locations(location) end)
    |> Enum.uniq()
  end

  defp adjacent_locations(location) do
    [
      [:e | location],
      [:w | location],
      [:se | location],
      [:sw | location],
      [:ne | location],
      [:nw | location]
    ]
    |> Enum.map(&simplify/1)
  end

  defp count_adjacent_black(location, black_tile_locations) do
    location
    |> adjacent_locations()
    |> Enum.count(fn adjacent_location ->
      MapSet.member?(black_tile_locations, adjacent_location)
    end)
  end

  defp initial_conditions(text) do
    data =
      text
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line -> line |> parse() |> simplify() end)

    data
    |> Enum.reduce(MapSet.new(), fn location, black_locations ->
      if MapSet.member?(black_locations, location) do
        MapSet.delete(black_locations, location)
      else
        MapSet.put(black_locations, location)
      end
    end)
  end

  def parse(text) do
    do_parse(text)
  end

  defp do_parse("w" <> rest), do: [:w | do_parse(rest)]
  defp do_parse("e" <> rest), do: [:e | do_parse(rest)]
  defp do_parse("ne" <> rest), do: [:ne | do_parse(rest)]
  defp do_parse("nw" <> rest), do: [:nw | do_parse(rest)]
  defp do_parse("sw" <> rest), do: [:sw | do_parse(rest)]
  defp do_parse("se" <> rest), do: [:se | do_parse(rest)]
  defp do_parse(""), do: []

  def simplify(directions) do
    directions
    |> Enum.flat_map(fn
      :ne -> [:e, :nw]
      :sw -> [:w, :se]
      direction -> [direction]
    end)
    |> Enum.reduce([], fn
      :w, acc ->
        if :e in acc do
          acc -- [:e]
        else
          [:w | acc]
        end

      :e, acc ->
        if :w in acc do
          acc -- [:w]
        else
          [:e | acc]
        end

      :se, acc ->
        if :nw in acc do
          acc -- [:nw]
        else
          [:se | acc]
        end

      :nw, acc ->
        if :se in acc do
          acc -- [:se]
        else
          [:nw | acc]
        end

      direction, acc ->
        [direction | acc]
    end)
    |> Enum.sort()
  end
end
