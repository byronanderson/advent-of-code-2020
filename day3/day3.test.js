const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

//# type Map = Array<Array<"#" | ".">>;
const map = input.split("\n").map(line => line.split(""));

function atLocation(map, [x, y]) {
  const row = map[y];
  if (!row) return ".";
  return row[x % map[0].length];
}

function part1(map) {
  let trees = 0;
  for (let i = 0; i < map.length; i++) {
    if (atLocation(map, [i * 3, i]) === "#") {
      trees++;
    }
  }
  console.log("part1", trees);
}

function check(map, slope) {
  const [numX, numY] = slope;
  let trees = 0;
  for (let i = 0; i < map.length; i++) {
    if (atLocation(map, [i * numX, i * numY]) === "#") {
      trees++;
    }
  }
  return trees;
}

function part2(map) {
  const result = check(map, [1, 1]) * 
  check(map, [3, 1]) *
  check(map, [5, 1]) *
  check(map, [7, 1]) *
  check(map, [1, 2])
  console.log("part2", result);
}


part1(map);
part2(map);
