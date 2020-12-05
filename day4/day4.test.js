const text = await Deno.readTextFile("./input.txt");


    // byr (Birth Year)
    // iyr (Issue Year)
    // eyr (Expiration Year)
    // hgt (Height)
    // hcl (Hair Color)
    // ecl (Eye Color)
    // pid (Passport ID)
    // cid (Country ID)


const input = text.trim();

const passports = input.split("\n\n").map(passport => (
  passport.split(/\s+/).filter(x => x)
)).map(entries => {
  let result = {};
  for (const entry of entries) {
    const [field, value] = entry.split(":");
    result[field] = value;
  }
  return result
});

function valid(passport) {
  return between(number(passport.byr), 1920, 2002) &&
    between(number(passport.iyr), 2010, 2020) &&
    between(number(passport.eyr), 2020, 2030) &&
    validateHeight(passport.hgt) &&
    validateHexColor(passport.hcl) &&
    validateEyeColor(passport.ecl) &&
    validatePassportId(passport.pid);
}

function between(value, lower, higher) {
  return value >= lower && value <= higher;
}

function number(string) {
  if (!string) return Number.NaN;
  if (string.match(/^\d+$/)) return Number(string);
  return Number.NaN;
}

function validateHeight(value) {
  if (!value) return false;
  const match = value.match(/^(\d+)((cm)|(in))$/);
  if (!match) return false;
  const magnitude = Number(match[1]);
  if (match[2] === "cm") {
    return between(magnitude, 150, 193);
  }
  if (match[2] === "in") {
    return between(magnitude, 59, 76);
  }
  return false;
}

function validateHexColor(color) {
  return !!(color || "").match(/^#[0-9a-f]{6}$/);
}

function validateEyeColor(eyeColor) {
  return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].includes(eyeColor);
}

function validatePassportId(passportId) {
  return !!(passportId || "").match(/^\d{9}$/);
}

console.log("valid passports", passports.filter(valid).length);

