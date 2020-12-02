const text = await Deno.readTextFile("./input.txt");

const input = text.trim().split("\n")


const regex = /(\d+)-(\d+) (\w): (.*)$/;
function validpart1(value) {
  const matchdata = value.match(regex);
  const lower = Number(matchdata[1]);
  const upper = Number(matchdata[2]);
  const criteria = matchdata[3];
  const password = matchdata[4];

  const occurances = password.split(criteria).length - 1;
  return occurances >= lower && occurances <= upper;
}

function validpart2(value) {
  const matchdata = value.match(regex);
  const lower = Number(matchdata[1]);
  const upper = Number(matchdata[2]);
  const criteria = matchdata[3];
  const password = matchdata[4];

  const first = password.charAt(lower - 1) === criteria;
  const second = password.charAt(upper - 1) === criteria;
  return xor(first, second);
}

function xor(one, two) {
  if (one && two) return false;
  if (!one && !two) return false;
  return true;
}

let numvalid1 = 0;
let numvalid2 = 0;
input.forEach(value => {
  if (validpart1(value)) {
    numvalid1 += 1;
  }
  if (validpart2(value)) {
    numvalid2 += 1;
  }
});

console.log("part 1: ", numvalid1);
console.log("part 2: ", numvalid2);

