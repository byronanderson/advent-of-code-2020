defmodule Day20 do
  @input File.read!(__DIR__ <> "/day_20_input.txt")

  def part1(text \\ @input) do
    data = parse(text)

    sides_map = Enum.map(data, fn tile -> {tile, sides_with_name(tile)} end) |> Enum.into(%{})

    Enum.map(data, fn tile ->
      tile |> Map.put(:adjacents, find_adjacents(tile, data -- [tile], sides_map))
    end)
    |> Enum.filter(fn tile -> tile.adjacents |> Enum.filter(&elem(&1, 1)) |> length() == 2 end)
    |> Enum.map(& &1.id)
    |> Enum.reduce(1, fn x, y -> x * y end)
  end

  def part2(text \\ @input) do
    data = parse(text)

    sides_map = Enum.map(data, fn tile -> {tile, sides_with_name(tile)} end) |> Enum.into(%{})

    tiles =
      Enum.map(data, fn tile ->
        tile |> Map.put(:adjacents, find_adjacents(tile, data -- [tile], sides_map))
      end)

    # do all the sides first
    # corner, pick either of them, go down the side until you reach another corner
    corner =
      Enum.find(tiles, fn tile -> Enum.count(tile.adjacents, fn {_, thing} -> thing end) == 2 end)

    orient_corner_so_that_it_is_in_the_top_left = fn tile ->
      Enum.reduce_while(0..3, tile, fn _, tile ->
        if tile.adjacents[:right] && tile.adjacents[:bottom] do
          {:halt, tile}
        else
          {:cont, left_rotate_tile(tile)}
        end
      end)
    end

    corner = orient_corner_so_that_it_is_in_the_top_left.(corner)
    image = build_image([[corner]], {1, 0}, tiles)

    tile_size = %{
      height: corner.image |> length(),
      width: corner.image |> Enum.at(0) |> length()
    }

    image
    |> Enum.each(fn row ->
      Enum.map(row, fn tile ->
        "tile: #{tile.id}"
      end)
      |> Enum.join(", ")
      |> IO.puts()
    end)

    full_image =
      image
      |> Enum.flat_map(fn image_line ->
        Enum.map(1..(tile_size.height - 2), fn sub_y ->
          image_line
          |> Enum.map(fn tile ->
            tile.image
            |> Enum.at(sub_y)
            |> Enum.slice(1, tile_size.width - 2)
          end)
          |> Enum.join("")
        end)
      end)
      |> Enum.join("\n")

    string_to_2d_list = fn string ->
      String.split(string, "\n")
      |> Enum.map(fn line -> String.split(line, "") |> Enum.filter(fn x -> x != "" end) end)
    end

    orientations =
      for transpose <- [:dont_transpose, :do_transpose],
          rotations <- 0..3,
          do: {transpose, rotations}

    reorient = fn
      image, {transpose, rotations} ->
        image =
          case transpose do
            :dont_transpose -> image
            :do_transpose -> transpose(image)
          end

        image = image |> left_rotate(rotations)
    end

    seadragons =
      orientations
      |> Enum.map(fn orientation ->
        reorient.(full_image, orientation)
      end)
      |> Enum.map(fn full_image ->
        bits = string_to_2d_list.(full_image)
        image_height = length(bits)
        image_width = length(List.first(bits))
        seadragon_width = 20
        seadragon_height = 3

        # chop up width substrings of the width of the seadragon
        # chop up height substrings of the height of the seadragon
        Enum.map(0..image_width, fn x ->
          subbits =
            Enum.map(bits, fn line ->
              Enum.slice(line, x, seadragon_width)
            end)

          Enum.count(0..image_height, fn y ->
            subsubbits = subbits |> Enum.slice(y, seadragon_height)

            case subsubbits do
              [
                [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, "#", _],
                ["#", _, _, _, _, "#", "#", _, _, _, _, "#", "#", _, _, _, _, "#", "#", "#"],
                [_, "#", _, _, "#", _, _, "#", _, _, "#", _, _, "#", _, _, "#", _, _, _]
              ] = z ->
                true

              _ ->
                false
            end
          end)
        end)
        |> Enum.sum()
      end)
      |> Enum.max()

    full_image
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.put(acc, char, (acc[char] || 0) + 1)
    end)
    |> Map.get("#")
    |> Kernel.-(seadragons * 15)
  end

  defp enum_at_without_negative_index(_enum, index) when index < 0, do: nil
  defp enum_at_without_negative_index(enum, index), do: Enum.at(enum, index)

  defp build_image(partial_image, {x, y}, tiles) do
    already_placed_to_the_left =
      partial_image |> Enum.at(y) |> Kernel.||([]) |> enum_at_without_negative_index(x - 1)

    already_placed_above =
      partial_image |> Enum.at(y - 1) |> Kernel.||([]) |> enum_at_without_negative_index(x)

    tiles_match = fn
      %{id: id}, %{id: id} -> true
      nil, nil -> true
      _, _ -> false
    end

    rotate_and_flip_tile_so_that_left_side_is_empty_top_side_aligns_with_bottom_of = fn tile,
                                                                                        above ->
      Enum.reduce_while(0..3, tile, fn _, tile ->
        if tiles_match.(tile.adjacents[:top], above) do
          if tile.adjacents[:left] do
            {:halt,
             transpose_tile(tile)
             |> left_rotate_tile()
             |> left_rotate_tile()
             |> left_rotate_tile()}
          else
            {:halt, tile}
          end
        else
          {:cont, left_rotate_tile(tile)}
        end
      end)
    end

    rotate_and_flip_tile_so_that_left_side_aligns_with_right_and_bottom_side_of = fn tile,
                                                                                     left,
                                                                                     top ->
      Enum.reduce_while(0..3, tile, fn _, tile ->
        if tiles_match.(tile.adjacents[:left], left) do
          if tiles_match.(tile.adjacents[:top], top) do
            {:halt, tile}
          else
            {:halt,
             transpose_tile(tile)
             |> left_rotate_tile()}
          end
        else
          {:cont, left_rotate_tile(tile)}
        end
      end)
    end

    find_tile_with_adjacents = fn tile ->
      Enum.find(tiles, fn %{id: id} -> id == tile.id end)
    end

    case {x, already_placed_to_the_left, already_placed_above} do
      {0, _, %{adjacents: %{bottom: nil}}} ->
        partial_image

      {0, _, %{adjacents: %{bottom: next_tile}} = above_tile} ->
        next_tile =
          next_tile
          |> find_tile_with_adjacents.()
          |> rotate_and_flip_tile_so_that_left_side_is_empty_top_side_aligns_with_bottom_of.(
            above_tile
          )

        build_image(partial_image ++ [[next_tile]], {x + 1, y}, tiles)

      {_, %{adjacents: %{right: nil}} = left_tile, _} ->
        build_image(partial_image, {0, y + 1}, tiles)

      {_, %{adjacents: %{right: next_tile}} = left_tile, top_tile} ->
        last_index = length(partial_image) - 1
        next_tile = find_tile_with_adjacents.(next_tile)

        partial_image
        |> Enum.with_index()
        |> Enum.map(fn
          {line, ^last_index} ->
            line ++
              [
                rotate_and_flip_tile_so_that_left_side_aligns_with_right_and_bottom_side_of.(
                  next_tile,
                  left_tile,
                  top_tile
                )
              ]

          {line, _} ->
            line
        end)
        |> build_image({x + 1, y}, tiles)
    end
  end

  def inspect_tile(nil), do: IO.puts("empty tile")

  def inspect_tile(tile) do
    img = tile.image |> Enum.map(fn line -> Enum.join(line, "") end) |> Enum.join("\n")

    adjacents =
      Enum.filter(tile.adjacents, fn {_, data} -> data end)
      |> Enum.map(fn {direction, adjacent} -> "#{direction}: #{adjacent.id}" end)
      |> Enum.join(", ")

    IO.puts("""
    Tile: #{tile.id}.  Adjacents: #{adjacents}
    #{img}
    """)

    tile
  end

  defp find_adjacents(tile, others, sides_map) do
    data =
      sides_map[tile]
      |> Enum.map(fn {name, target_side} ->
        adjacent =
          others
          |> Enum.filter(fn other ->
            Enum.any?(sides_map[other] |> Enum.map(&elem(&1, 1)), fn side ->
              side == target_side or side == Enum.reverse(target_side)
            end)
          end)

        if length(adjacent) > 1 do
          raise "uh oh"
        end

        {name, List.first(adjacent)}
      end)
      |> Enum.into(%{})

    data
  end

  defp sides_with_name(tile) do
    rotated_once = left_rotate(tile.image)
    rotated_twice = left_rotate(rotated_once)
    rotated_thrice = left_rotate(rotated_twice)

    top = List.first(tile.image)
    right = List.first(rotated_once)
    bottom = List.first(rotated_twice)
    left = List.first(rotated_thrice)

    %{top: top, right: right, bottom: bottom, left: left}
  end

  defp parse(text) do
    text |> String.trim() |> String.split("\n\n") |> Enum.map(&parse_tile/1)
  end

  defp parse_tile(text) do
    [id_line | image_lines] = String.split(text, "\n")
    [_, id_string] = Regex.run(~r/Tile (\d+):/, text)
    id = parse_int!(id_string)

    image =
      image_lines
      |> Enum.map(fn line ->
        line
        |> String.split("")
        |> Enum.filter(fn str -> str != "" end)
      end)

    %{id: id, image: image}
  end

  defp parse_int!(string) do
    {number, ""} = Integer.parse(string)
    number
  end

  defp left_rotate_tile(tile) do
    %{
      tile
      | image: left_rotate(tile.image),
        adjacents: %{
          left: tile.adjacents[:top],
          top: tile.adjacents[:right],
          right: tile.adjacents[:bottom],
          bottom: tile.adjacents[:left]
        }
    }
  end

  defp transpose_tile(tile) do
    %{
      tile
      | image: Enum.zip(tile.image) |> Enum.map(&Tuple.to_list/1),
        adjacents: %{
          left: tile.adjacents[:top],
          top: tile.adjacents[:left],
          right: tile.adjacents[:bottom],
          bottom: tile.adjacents[:right]
        }
    }
  end

  defp transpose(string) when is_binary(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split("") |> Enum.reject(&(&1 == "")) end)
    |> transpose()
    |> Enum.map(fn line -> Enum.join(line, "") end)
    |> Enum.join("\n")
  end

  defp transpose(list_of_lists) do
    Enum.zip(list_of_lists) |> Enum.map(&Tuple.to_list/1)
  end

  defp left_rotate(data, rotations) when is_integer(rotations) and rotations > 0 do
    data |> left_rotate() |> left_rotate(rotations - 1)
  end

  defp left_rotate(data, 0), do: data

  defp left_rotate(string) when is_binary(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split("") |> Enum.reject(&(&1 == "")) end)
    |> left_rotate()
    |> Enum.map(fn line -> Enum.join(line, "") end)
    |> Enum.join("\n")
  end

  defp left_rotate(list) do
    Enum.zip(list) |> Enum.reverse() |> Enum.map(&Tuple.to_list/1)
  end

  defp tap(data, func) do
    func.(data)
    data
  end
end
