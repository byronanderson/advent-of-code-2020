defmodule Day16Test do
  use ExUnit.Case

  @tag timeout: :infinity
  test "works" do
    assert Day16.part1("""
           class: 1-3 or 5-7
           row: 6-11 or 33-44
           seat: 13-40 or 45-50

           your ticket:
           7,1,14

           nearby tickets:
           7,3,47
           40,4,50
           55,2,20
           38,6,12
           """) == 71

    IO.inspect(Day16.part1(), label: "part 1")

    # assert Day16.identify("""
    #        class: 0-1 or 4-19
    #        row: 0-5 or 8-19
    #        seat: 0-13 or 16-19

    #        your ticket:
    #        11,12,13

    #        nearby tickets:
    #        3,9,18
    #        15,1,5
    #        5,14,9
    #        """) == ["row", "class", "seat"]

    IO.inspect(Day16.part2(), label: "part 2")
  end
end

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
