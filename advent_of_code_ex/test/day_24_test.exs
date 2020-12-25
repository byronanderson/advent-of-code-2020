defmodule Day24Test do
  use ExUnit.Case

  test "parsing" do
    assert Day24.parse("eseswwnwneewe") == [:e, :se, :sw, :w, :nw, :ne, :e, :w, :e]
  end

  test "simplifying opposite directions" do
    assert simplify_text("ew") == simplify_text("we")
    assert simplify_text("senw") == simplify_text("nesw")
    assert simplify_text("senw") == simplify_text("nesw")
  end

  test "simplifying makes a canonical identifier for directions of ambiguous routes to the same tile" do
    assert simplify_text("swse") == simplify_text("sesw")
    assert simplify_text("eswsw") == simplify_text("sesw")
    assert simplify_text("wsese") == simplify_text("sesw")
  end

  test "works" do
    fixture = """
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """

    assert Day24.part1(fixture) == 10
    IO.inspect(Day24.part1(), label: "part 1")

    # assert Day24.part2(fixture) == 2208
    IO.inspect(Day24.part2(), label: "part 2")
  end

  def simplify_text(text) do
    text
    |> Day24.parse()
    |> Day24.simplify()
  end
end
