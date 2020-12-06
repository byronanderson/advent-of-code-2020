import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("suggested tests", () => {
  const fixture = `
abc

a
b
c

ab
ac

a
a
a
a

b
  `
  assertEquals(part1(fixture), 11);
  assertEquals(part2(fixture), 6);
});

function part1(text = input) {
  const data = text.trim();
  const groupSizes = data.split("\n\n").map(group => {
    const any = new Set();
    group.split("\n").map(passenger => {
      passenger.split("").forEach(value => any.add(value));
    })
    return any.size;
  })
  const sum = list => list.reduce((x, y) => x + y, 0);
  return sum(groupSizes);
}

function part2(text = input) {
  const data = text.trim();
  const groupSizes = data.split("\n\n").map(group => {
    const sets = group.split("\n").map(passenger => {
      const set = new Set();
      passenger.split("").forEach(value => set.add(value));
      return set;
    })
    const intersection = (set1, set2) => new Set([...set1].filter(x => set2.has(x)));
    const all = list => list.reduce((x, y) => intersection(x, y));
    return all(sets).size;
  })
  const sum = list => list.reduce((x, y) => x + y, 0);
  return sum(groupSizes);
}

console.log("part1", part1());
console.log("part2", part2());
