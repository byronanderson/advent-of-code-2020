import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("foo", () => {
  const fixture = `
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
  `
  assertEquals(part1(fixture, 5), 127);
  assertEquals(part2(fixture, 5), 62);
});

const parse = (text: string): Array<number> => text.trim().split("\n").map((number: string) => parseInt(number));
function part1(text = input, preambleLength = 25) {
  const numbers = parse(text);
  for (let i = preambleLength; i < numbers.length; i++) {
    if (!valid(numbers, i, preambleLength)) return numbers[i];
  }
}

function combinations(numbers: Array<number>): Array<[number, number]> {
  const result: Array<[number, number]> = [];
  for (let i = 0; i < numbers.length; i++) {
    for (let j = i + 1; j < numbers.length; j++) {
      result.push([numbers[i], numbers[j]])
    }
  }
  return result;
}

function valid(numbers: Array<number>, index: number, preambleLength: number) {
  return combinations(numbers.slice(index - preambleLength, index)).some(([first, second]: [number, number]) => first + second === numbers[index]);
}
const sum = (arr: Array<number>) => arr.reduce((x: number, y: number) => x + y);

function part2(text = input, preambleLength = 25) {
  const target = part1(text, preambleLength);
  const numbers = parse(text);
  function findSpan() {
    for (let i = 0; i < numbers.length; i++) {
      for (let j = i; j< numbers.length; j++) {
        if (sum(numbers.slice(i, j + 1)) === target) {
          return numbers.slice(i, j + 1);
        }
      }
    }
  }

  const span = findSpan();
  if (span) {
    return Math.max(...span) + Math.min(...span);
  }
}

console.log(part1());
console.log(part2());
