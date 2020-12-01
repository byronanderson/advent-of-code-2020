const text = await Deno.readTextFile("./input.txt");

const input = text.trim().split("\n").map(entry => Number(entry))
console.log(input);

input.forEach(value => {
  input.forEach(other => {
    if (value + other === 2020) {
      console.log("found: ", value, other);
      console.log(value * other)
    }
  })
});

input.forEach(value => {
  input.forEach(other => {
    if (value + other >= 2020) return;
    input.forEach(third => {
      if (value + other + third === 2020) {
        console.log("found: ", value, other, third);
        console.log(value * other * third)
      }
    })
  })
});

