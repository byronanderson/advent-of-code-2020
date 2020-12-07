import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.79.0/testing/asserts.ts";

const text = await Deno.readTextFile("./input.txt");

const input = text.trim();

Deno.test("suggested tests", () => {
  const fixture = `
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
  `
  assertEquals(part1(fixture), 4);
  assertEquals(part2(fixture), 32);
});

const values = {};
function memoize(fn) {
  return function(...args) {
    const key = args.join("");
    if (Object.hasOwnProperty(values, key)) return values[key];
    values[key] = fn(...args);
    return values[key];
  }
}

function part1(text = input) {
  const data = text.trim();
  const rules = data.split("\n").reduce((acc, line) => {
    const [bagType, contentsString] = line.split("s contain ")
    const contents = contentsString.split(", ").reduce((acc, oneTypeOfBag) => {
      if (oneTypeOfBag === "no other bags.") {
        return acc;
      } else {
        const [_, number, type] = oneTypeOfBag.match(/^(\d+) (.* bag)s?\.?$/);
        return [...acc, {type, number}];
      }
    }, []);
    return {...acc, [bagType]: contents};
  }, {});

  const canContain = memoize(function canContain_(bagType, targetType) {
    if (bagType === targetType) return false;
    if (rules[bagType].some(rule => rule.type === targetType)) {
      return true;
    }
    return rules[bagType].some(rule => {
      const thing = canContain(rule.type, targetType);
      return thing;
    })
  });

  return Object.keys(rules).filter(bagType => canContain(bagType, "shiny gold bag")).length;
}

function part2(text = input) {
  const data = text.trim();
  const rules = data.split("\n").reduce((acc, line) => {
    const [bagType, contentsString] = line.split("s contain ")
    const contents = contentsString.split(", ").reduce((acc, oneTypeOfBag) => {
      if (oneTypeOfBag === "no other bags.") {
        return acc;
      } else {
        const [_, number, type] = oneTypeOfBag.match(/^(\d+) (.* bag)s?\.?$/);
        return [...acc, {type, number: Number(number)}];
      }
    }, []);
    return {...acc, [bagType]: contents};
  }, {});
  function countBags(type) {
    return rules[type].map(rule => countBags(rule.type) * rule.number).reduce((a, b) => a + b, 1);
  }
  return countBags("shiny gold bag") - 1;
}

console.log("part1", part1());
console.log("part2", part2());
