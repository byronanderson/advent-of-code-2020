defmodule Day25 do
  @input """
  17607508
  15065270
  """
  def part1(text \\ @input) do
    # door has public/private key pair
    # card has public/private key pair

    [public_key_1, public_key_2] =
      text
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_int!/1)
      |> IO.inspect(label: "public keys")

    calculate(
      public_key_2,
      crack_private_loop_size(public_key_1, 7)
    )
  end

  def part2(text \\ @input) do
  end

  def crack_private_loop_size(public_key, subject) do
    crack_private_loop_size(public_key, subject, 1, 0)
  end

  defp crack_private_loop_size(public_key, subject, value, iterations) do
    if value == public_key do
      iterations
    else
      value = rem(value * subject, 20_201_227)
      crack_private_loop_size(public_key, subject, value, iterations + 1)
    end
  end

  defp calculate(subject, loop_size, value \\ 1)
  defp calculate(_subject, 0, value), do: value

  defp calculate(subject, loop_size, value) do
    value = rem(value * subject, 20_201_227)
    calculate(subject, loop_size - 1, value)
  end

  defp parse_int!(string) do
    {number, ""} = Integer.parse(string)
    number
  end
end
