import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("foo", () => {
  const fixture = `
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
  `
  assertEquals(part1(fixture), 5);
  assertEquals(part2(fixture), 8);
});

function part1(text = input) {
  return doExecute(instructions(text)).acc;
}

type Instruction = {
  cmd: "nop" | "jmp" | "acc",
  value: number
};

function instructions(text: string): Array<Instruction> {
  return text.trim().split("\n").map(text => {
    const [cmd, valuestring] = text.split(" ");
    const value = Number(valuestring);
    return {cmd, value} as Instruction;
  });
}

function doExecute(program: Array<Instruction>) {
  let acc = 0;
  let address = 0;
  let done = false;
  let looped = false;
  const visited = new Set();

  function execute(instruction: any) {
    if (visited.has(address)) {
      looped = true;
      done = true;
      return;
    }
    visited.add(address);
    switch (instruction.cmd) {
      case "nop":
        address += 1;
        break;
      case "acc":
        acc += instruction.value;
        address += 1;
        break;
      case "jmp":
        address += instruction.value;
        break;
    }
  }

  while (!done) {
    if (address >= program.length) break;
    execute(program[address]);
  }

  return {looped, acc};
}

function part2(text = input) {
  const program = instructions(text);
  for (let i = 0; i < program.length; i++) {
    if (program[i].cmd === "jmp") {
      const modifiedProgram = [...program];
      modifiedProgram[i] = {...modifiedProgram[i], cmd: "nop"};
      const result = doExecute(modifiedProgram);
      if (!result.looped) return result.acc;
    }
  }
}

console.log(part1());
console.log(part2());
