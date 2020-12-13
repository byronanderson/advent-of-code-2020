import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("foo", () => {
  const fixture = `
939
7,13,x,x,59,x,31,19
  `
  assertEquals(part1(fixture), 295);
  console.log(part1());
  assertEquals(part2(fixture), 1068781);
  console.log(part2());
});

const parse = (text: string) => {
  const [line1, line2] = text.trim().split("\n")
  return {
    earliest: parseInt(line1),
    buses: line2.split(",").map(x => x === "x" ? 0 : parseInt(x)).filter(x => x).sort((x: number, y: number) => x - y)
  };
}
function part1(text = input) {
  const data = parse(text);
  const bus = minBy(data.buses, (bus: any) => bus - data.earliest % bus);
  return bus * (bus - data.earliest % bus)
}

const requirements = (text: string): any => {
  const [line1, line2] = text.trim().split("\n")
  return line2.split(",").map((x, offset) => x === "x" ? 0 : { id: parseInt(x), offset: offset % parseInt(x) }).filter(x => x).sort((x: any, y: any) => x.id - y.id);
}

function part2(text = input) {
  const wolframQuery = requirements(text).map((thing: any) => `(t + ${thing.offset}) mod ${thing.id} = 0`).join(", ")
  console.log("go to wolfram and input this equation: ", wolframQuery);
  console.log("then the smallest of those will be where n=0 from the equation that they spit out");
}

// t % 13 = (13 - 2) % 13 = 11
// t % 17 = (17 - 7) % 17 = 10
// t % 41 = (41 - 0) % 41 = 0
// t = 13z + 11 where z is an integer

// t % 557 = (557 - 41) % 557 = 516
// t % 419 = (419 - 72) % 419 = 347

// t = 419 * x + 347
// t = 557 * y + 516
// (x * 419 + 72) = (557 * y + 41)

// 72 - 41 = 557 * y - 419 * x
// 31 = 557 * y - 419 * x
// is there an efficient way to calculate this?

// (419 * x + 31) / 557 = y -> find all integers where this is the case???
// 557 / 419

// at x = 1; y = 0.807
// ratio of y to x = y = 419 * x / 557, with an offset at 31/557
// at x = 1, y = (419 + 31) / 557
// I'm looking for spots where x and y are both integers
// 419 * x + 31 = y * 557
// x and y are integers where that division is gone:
// i.e. don't do the division , consider 557 * y to be z
// z = 419 * x + 31
// 557, 450
// 1114, 869

// find the spot where two are consecutive??

// then maybe that will do something good?

// but that doesn't help eliminate the field at all!!!

// 419 + 31 / 557


function minBy(list: any, lambda: any) {
  var lambdaFn;
  if (typeof(lambda) === "function") {
      lambdaFn = lambda;
  } else {
      lambdaFn = function(x: any){
          return x[lambda];
      }
  }
  var mapped = list.map(lambdaFn); 
  var minValue = Math.min.apply(Math, mapped); 
  return list[mapped.indexOf(minValue)];
}
