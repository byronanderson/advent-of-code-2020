const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

function seatId(data) {
  // FFFBFBFLRR
  const binary = data.replace(/[BR]/g, "1").replace(/[FL]/g, "0");
  return parseInt(binary, 2);
}

console.log(seatId("BFFFBBFRRR"), 567);

function part1() {
  return Math.max(...input.split("\n").map(seatId))
}

function part2() {
  const set = new Set(input.split("\n").map(seatId));
  console.log(set);
  console.log(set.has(825));
  for (let i = 0; i < part1(); i++) {
    if (!set.has(i)) {
      console.log("missing", i);
    }
  }
}

console.log("part1", part1());
console.log("part2", part2());
