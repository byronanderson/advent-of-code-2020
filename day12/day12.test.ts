import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("foo", () => {
  const fixture = `
F10
N3
F7
R90
F11
  `
  assertEquals(part1(fixture), 25);
  assertEquals(part2(fixture), 286);
});

const parse = (text: string) => text.trim().split("\n").map(line => ({
  instruction: line.substring(0, 1),
  value: parseInt(line.substring(1, 100))
}))

type Direction = "east" | "west" | "north" | "south";


function directionToDegrees(direction: Direction): number {
  switch (direction) {
    case "north":
      return 0;
    case "east":
      return 90;
    case "south":
      return 180;
    case "west":
      return 270;
  }
}
function degreesToDirection(degrees: number) {
  degrees = degrees % 360;
  switch (degrees) {
    case 0:
      return "north";
    case 90:
      return "east";
    case 180:
      return "south";
    case 270:
      return "west";
  }
}

function part1(text = input) {
  let facing: Direction = "east";
  let location = [0, 0];
  function go(direction: Direction, amount: number) {
    switch (direction) {
      case "east":
        location[0] = location[0] + amount;
        break;
      case "west":
        location[0] = location[0] - amount;
        break;
      case "north":
        location[1] = location[1] + amount;
        break;
      case "south":
        location[1] = location[1] - amount;
        break;
    }
  }
  function turn(degrees: number) {
    facing = degreesToDirection(directionToDegrees(facing) + degrees) as Direction;
  }
  parse(text).forEach(({instruction, value}) => {
    switch (instruction) {
      case "N":
        go("north", value);
        break;
      case "S":
        go("south", value);
        break;
      case "E":
        go("east", value);
        break;
      case "W":
        go("west", value);
        break;
      case "F":
        go(facing, value);
        break;
      case "L":
        turn(360 - value);
        break;
      case "R":
        turn(value);
        break;
    }
    // console.log(instruction, value, facing, location)
  });
  return Math.abs(location[0]) + Math.abs(location[1]);
}

function part2(text = input) {
  let location = [0, 0];
  let waypointRelativePosition = [10, 1];

  function positionWaypoint(direction: Direction, amount: number) {
    switch (direction) {
      case "east":
        waypointRelativePosition[0] = waypointRelativePosition[0] + amount;
        break;
      case "west":
        waypointRelativePosition[0] = waypointRelativePosition[0] - amount;
        break;
      case "north":
        waypointRelativePosition[1] = waypointRelativePosition[1] + amount;
        break;
      case "south":
        waypointRelativePosition[1] = waypointRelativePosition[1] - amount;
        break;
    }
  }

  function moveToWaypoint() {
    location = [location[0] + waypointRelativePosition[0], location[1] + waypointRelativePosition[1]];
  }

  function turnWaypoint(degrees: number) {
    // degreesToDirection(directionToDegrees(facing) + degrees) as Direction;
    switch (degrees) {
      case 0:
        break;
      case 90:
        waypointRelativePosition = [waypointRelativePosition[1], -waypointRelativePosition[0]]
        break;
      case 180:
        waypointRelativePosition = [-waypointRelativePosition[0], -waypointRelativePosition[1]]
        break;
      case 270:
        waypointRelativePosition = [-waypointRelativePosition[1], waypointRelativePosition[0]]
        break;
      default:
        throw new Error("waht? " + degrees);
    }
  }

  parse(text).forEach(({instruction, value}) => {
    switch (instruction) {
      case "N":
        positionWaypoint("north", value);
        break;
      case "S":
        positionWaypoint("south", value);
        break;
      case "E":
        positionWaypoint("east", value);
        break;
      case "W":
        positionWaypoint("west", value);
        break;
      case "F":
        for (let i = 0; i < value; i++) {
          moveToWaypoint();
        }
        break;
      case "L":
        turnWaypoint(360 - value);
        break;
      case "R":
        turnWaypoint(value);
        break;
    }
    // console.log(instruction, value, location, waypointRelativePosition)
  });
  return Math.abs(location[0]) + Math.abs(location[1]);
}

console.log(part1());
console.log(part2());
