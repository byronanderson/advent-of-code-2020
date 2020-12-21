defmodule Day21 do
  @input File.read!(__DIR__ <> "/day_21_input.txt")

  def part1(text \\ @input) do
    foods = parse(text)

    all_ingredients = foods |> Enum.flat_map(& &1.ingredients) |> MapSet.new()

    possible_allergens = possible_allergens(foods)

    could_not_be_allergens =
      all_ingredients
      |> Enum.reject(fn ingredient ->
        Enum.any?(possible_allergens, fn {_, ingredients} ->
          MapSet.member?(ingredients, ingredient)
        end)
      end)
      |> MapSet.new()

    foods
    |> Enum.flat_map(& &1.ingredients)
    |> Enum.count(fn ingredient -> MapSet.member?(could_not_be_allergens, ingredient) end)
  end

  def part2(text \\ @input) do
    foods = parse(text)

    possible_allergens = possible_allergens(foods)

    find_allergens(possible_allergens, %{})
    |> Enum.sort_by(fn {ingredient, allergen} -> allergen end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(",")
  end

  defp find_allergens(possible_allergens, known_allergens) do
    if Enum.empty?(possible_allergens) do
      known_allergens
    else
      {allergen, ingredients} =
        Enum.find(possible_allergens, fn {_, ingredients} -> Enum.count(ingredients) == 1 end)

      found_ingredient = Enum.at(ingredients, 0)
      known_allergens = Map.put(known_allergens, found_ingredient, allergen)

      possible_allergens =
        possible_allergens
        |> Map.delete(allergen)
        |> Enum.map(fn {allergen, ingredients} ->
          {allergen, ingredients |> MapSet.delete(found_ingredient)}
        end)
        |> Enum.into(%{})

      find_allergens(possible_allergens, known_allergens)
    end
  end

  defp possible_allergens(foods) do
    all_allergens = foods |> Enum.flat_map(& &1.allergens) |> MapSet.new()
    all_ingredients = foods |> Enum.flat_map(& &1.ingredients) |> MapSet.new()

    possible_allergens =
      foods
      |> Enum.reduce(%{}, fn food, acc ->
        food.allergens
        |> Enum.reduce(acc, fn allergen, acc ->
          acc
          |> Map.put_new(allergen, MapSet.new(food.ingredients))
          |> Map.update!(allergen, &MapSet.intersection(&1, MapSet.new(food.ingredients)))
        end)
      end)
  end

  defp parse(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [_, ingredients_text, allergens_text] = Regex.run(~r/(.*) \(contains (.*)\)/, line)

      %{
        ingredients: ingredients_text |> String.split(" "),
        allergens: allergens_text |> String.split(", ")
      }
    end)
  end

  defp tap(data, func) do
    func.(data)
    data
  end

  defp parse_int!(string) do
    {number, ""} = Integer.parse(string)
    number
  end
end
