import {
    assertArrayIncludes,
    assertEquals,
  } from "https://deno.land/std@0.79.0/testing/asserts.ts";
  
const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("foo", () => {
  const fixture = `
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
  `
  assertEquals(part1(fixture), 37);
  assertEquals(countAdjacent2(parse(`
.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....
  `), 4, 3, "#"), 8);

  assertEquals(countAdjacent2(parse(`
.............
.L.L.#.#.#.#.
.............
  `), 1, 1, "#"), 0);
  // assertEquals(part2(fixture), 26)
  assertEquals(countAdjacent2(parse(`
#.##.##.##
#######.##
  `), 0, 2, "#"), 5)
});

const parse = (text: string) => text.trim().split("\n").map(line => line.split("") as Location[]);

type Location = "." | "#" | "L";
type Structure = Array<Array<Location>>;

function evolve(input: Structure): Structure {
  return input.map((line, y) => (
    line.map((location, x) => {
      switch (location) {
        case "L":
          if (countAdjacent(input, y, x, "#") === 0) {
            return "#";
          }
        case "#":
          if (countAdjacent(input, y, x, "#") >= 4) {
            return "L";
          }
      }
      return location
    })
  ))
}

function countAdjacent(structure: Structure, y: number, x: number, type: Location): number {
  const lineAbove = structure[y - 1];
  const sameLine = structure[y];
  const lineBelow = structure[y + 1];

  let sum = 0;
  if (lineAbove) {
    if (lineAbove[x - 1] === type) sum += 1;
    if (lineAbove[x] === type) sum += 1;
    if (lineAbove[x + 1] === type) sum += 1;
  }
  if (sameLine[x - 1] === type) sum += 1;
  if (sameLine[x + 1] === type) sum += 1;
  if (lineBelow) {
    if (lineBelow[x - 1] === type) sum += 1;
    if (lineBelow[x] === type) sum += 1;
    if (lineBelow[x + 1] === type) sum += 1;
  }
  return sum;
}

function stringify(structure: Structure) {
  return structure.map(line => line.join("")).join("\n");
}

function part1(text = input) {
  let current = parse(text);
  let next;
  let done = false;

  while (!done) {
    next = evolve(current);
    done = stringify(next) === stringify(current);
    current = next;
  }
  return stringify(current).split("#").length - 1;
}

function evolve2(input: Structure): Structure {
  return input.map((line, y) => (
    line.map((location, x) => {
      switch (location) {
        case "L":
          if (countAdjacent2(input, y, x, "#") === 0) {
            return "#";
          }
        case "#":
          if (countAdjacent2(input, y, x, "#") >= 5) {
            return "L";
          }
      }
      return location
    })
  ))
}

function part2(text = input) {
  let current = parse(text);
  let next;
  let done = false;

  while (!done) {
    next = evolve2(current);
    done = stringify(next) === stringify(current);

    console.log()
    console.log(stringify(current));
    current = next;
  }
  return stringify(current).split("#").length - 1;
}

function findDirection(structure: Structure, y: number, x: number, directionY: number, directionX: number): Location | undefined | null {
  if (!structure[y + directionY]) return null;
  if (structure[y + directionY][x + directionX] === ".") {
    return findDirection(structure, y + directionY, x + directionX, directionY, directionX);
  }
  return structure[y + directionY][x + directionX];
}

function countAdjacent2(structure: Structure, y: number, x: number, type: Location): number {
  const lineAbove = structure[y - 1];
  const sameLine = structure[y];
  const lineBelow = structure[y + 1];

  const aboveLeft = findDirection(structure, y, x, -1, -1);
  const above = findDirection(structure, y, x, -1, 0);
  const aboveRight = findDirection(structure, y, x, -1, 1);
  const left = findDirection(structure, y, x, 0, -1);
  const right = findDirection(structure, y, x, 0, 1);
  const belowLeft = findDirection(structure, y, x, 1, -1);
  const below = findDirection(structure, y, x, 1, 0);
  const belowRight = findDirection(structure, y, x, 1, 1);

  let sum = 0;
  if (aboveLeft === type) sum += 1;
  if (above === type) sum += 1;
  if (aboveRight === type) sum += 1;
  if (left === type) sum += 1;
  if (right === type) sum += 1;
  if (belowLeft === type) sum += 1;
  if (below === type) sum += 1;
  if (belowRight === type) sum += 1;
  return sum;
}

console.log(part1());
console.log(part2());