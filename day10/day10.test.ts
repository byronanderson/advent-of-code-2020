import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";


const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

const groupBy = (list: any, fn: any) => list.reduce((hash: any, obj: any) => ({...hash, [fn(obj)]:( hash[fn(obj)] || [] ).concat(obj)}), {})

Deno.test("foo", () => {
  const fixture = `
16
10
15
5
1
11
7
19
6
12
4
  `;
  assertEquals(part1(fixture), 35);
  assertEquals(part2(fixture), 8);

  // efficiently count them up
  // i can skip intermediates

  // find the part 1 answer to find the longest route
  // then you can find all of the consecutive ones can be a two instead
  // consecutive 1,2 and 2,1 can be a 3
  // consecutive 1,1,1 can be a 3

  // for every one of those that you find ^^, you _double_ the number of possible solutions?
  // no...  but I'm not sure how it is wrong
  //
  // maybe:
  // consider each group of two consecutive differences
  // case: 1,1: multiply accumulator by 2
  // case: 1,2: m


  // maybe effective memoization will help here?


  // combinations(diffs)
  // combinations([1]), do: 1
  // combinations([2]), do: 1
  // combinations([3]), do: 1
  // combinations([1,3 | rest]), do: combinations([3 | rest])
  // combinations([2,3 | rest]), do: combinations([3 | rest])
  // combinations([1,2 | rest]), do: combinations([2 | rest]) + combinations([3 | rest])
  // combinations([2,1 | rest]), do: combinations([1 | rest]) + combinations([3 | rest])
  // combinations([1,1,1 | rest]), do: combinations([1,1 | rest]) + combinations([2,1 | rest]) + combinations([2 | rest]) + combinations([3 | rest])
  // combinations([2,1 | rest]), do: combinations([1 | rest]) + combinations([3 | rest])
  // combinations([3 | rest]), do: combinations(rest)
});
function eachCons<x>(array: Array<x>, num: number) {
  return Array.from({ length: array.length - num + 1 },
                    (_, i) => array.slice(i, i + num))
}
function part1(text = input) {
  const data: Array<number> = text.trim().split("\n").map((string: string) => parseInt(string));
  data.sort((x: number, y: number) => x - y);
  const diffs = eachCons([0, ...data], 2).map(([x, y]) => y - x);
  const grouped = groupBy(diffs, (x: any) => x)
  return grouped["1"].length * (grouped["3"].length + 1);
}

function part2(text = input) {
  const data: Array<number> = text.trim().split("\n").map((string: string) => parseInt(string));
  data.sort((x: number, y: number) => x - y);
  const diffs = eachCons([0, ...data], 2).map(([x, y]) => y - x);

  console.log(JSON.stringify(diffs))
}

console.log(part1());
console.log(part2());
