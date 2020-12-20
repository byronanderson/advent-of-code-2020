defmodule Day17 do
  @input File.read!(__DIR__ <> "/day_17_input.txt")

  def part1(text \\ @input) do
    iterations = 6
    initial_system = parse(text)
    # inspect_system(initial_system)

    evolve(initial_system, iterations)
    |> map_size()
  end

  def part2(text \\ @input) do
    iterations = 6
    initial_system = parse2(text)

    evolve2(initial_system, iterations)
    |> map_size()
  end

  defp parse(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      String.split(line, "")
      |> Enum.reject(fn str -> str == "" end)
      |> Enum.map(&parse_location!/1)
      |> Enum.with_index()
      |> Enum.map(fn {value, x} -> {{x, y, 0}, value} end)
    end)
    |> Enum.filter(fn {_location, value} -> value == :active end)
    |> Enum.into(%{})
  end

  defp parse2(text) do
    parse(text) |> Enum.map(fn {{x, y, z}, val} -> {{x, y, z, 0}, val} end) |> Enum.into(%{})
  end

  defp inspect_system(system) do
    xs = system |> Map.keys() |> Enum.map(&elem(&1, 0))
    ys = system |> Map.keys() |> Enum.map(&elem(&1, 1))
    zs = system |> Map.keys() |> Enum.map(&elem(&1, 2))

    Enum.each(min(zs)..max(zs), fn z ->
      z |> IO.inspect(label: "Z")

      Enum.map(min(ys)..max(ys), fn y ->
        Enum.map(min(xs)..max(xs), fn x ->
          case system[{x, y, z}] do
            :active -> "#"
            nil -> "."
          end
        end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")
      |> IO.puts()
    end)
  end

  defp evolve(system, 0), do: system

  defp evolve(system, iterations) do
    xs = system |> Map.keys() |> Enum.map(&elem(&1, 0))
    ys = system |> Map.keys() |> Enum.map(&elem(&1, 1))
    zs = system |> Map.keys() |> Enum.map(&elem(&1, 2))

    # inspect_system(system)

    new_system =
      Enum.flat_map((min(xs) - 1)..(max(xs) + 1), fn x ->
        Enum.flat_map((min(ys) - 1)..(max(ys) + 1), fn y ->
          Enum.map((min(zs) - 1)..(max(zs) + 1), fn z ->
            {{x, y, z}, evolve_coordinate(system, {x, y, z})}
          end)
        end)
      end)
      |> Enum.filter(fn {_location, value} -> value == :active end)
      |> Enum.into(%{})

    # inspect_system(new_system)

    evolve(new_system, iterations - 1)
  end

  defp evolve_coordinate(system, location, count_active_neighbors \\ &count_active_neighbors/2) do
    case system[location] do
      nil ->
        if count_active_neighbors.(system, location) == 3 do
          :active
        else
          :inactive
        end

      :active ->
        if count_active_neighbors.(system, location) in [2, 3] do
          :active
        else
          :inactive
        end
    end
  end

  defp is_active(:active), do: true
  defp is_active(nil), do: false

  defp count_active_neighbors(system, {x, y, z}) do
    Enum.flat_map(-1..1, fn x_offset ->
      Enum.flat_map(-1..1, fn y_offset ->
        Enum.map(-1..1, fn z_offset ->
          case {x_offset, y_offset, z_offset} do
            {0, 0, 0} -> false
            _ -> is_active(system[{x + x_offset, y + y_offset, z + z_offset}])
          end
        end)
      end)
    end)
    |> Enum.count(fn x -> x end)
  end

  defp max(list), do: Enum.max(list)
  defp min(list), do: Enum.min(list)

  defp parse_location!("#"), do: :active
  defp parse_location!("."), do: :inactive

  defp evolve2(system, 0), do: system

  defp evolve2(system, iterations) do
    xs = system |> Map.keys() |> Enum.map(&elem(&1, 0))
    ys = system |> Map.keys() |> Enum.map(&elem(&1, 1))
    zs = system |> Map.keys() |> Enum.map(&elem(&1, 2))
    ws = system |> Map.keys() |> Enum.map(&elem(&1, 3))

    new_system =
      Enum.flat_map((min(xs) - 1)..(max(xs) + 1), fn x ->
        Enum.flat_map((min(ys) - 1)..(max(ys) + 1), fn y ->
          Enum.flat_map((min(zs) - 1)..(max(zs) + 1), fn z ->
            Enum.map((min(ws) - 1)..(max(ws) + 1), fn w ->
              {{x, y, z, w}, evolve_coordinate(system, {x, y, z, w}, &count_active_neighbors2/2)}
            end)
          end)
        end)
      end)
      |> Enum.filter(fn {_location, value} -> value == :active end)
      |> Enum.into(%{})

    evolve2(new_system, iterations - 1)
  end

  defp count_active_neighbors2(system, {x, y, z, w}) do
    Enum.flat_map(-1..1, fn x_offset ->
      Enum.flat_map(-1..1, fn y_offset ->
        Enum.flat_map(-1..1, fn z_offset ->
          Enum.map(-1..1, fn w_offset ->
            case {x_offset, y_offset, z_offset, w_offset} do
              {0, 0, 0, 0} -> false
              _ -> is_active(system[{x + x_offset, y + y_offset, z + z_offset, w + w_offset}])
            end
          end)
        end)
      end)
    end)
    |> Enum.count(fn x -> x end)
  end
end
