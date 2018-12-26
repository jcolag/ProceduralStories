const fs = require('fs');

const population = loadGrid('population_density_deg.csv');
const countries = loadGrid('country_deg.csv');
const ciafact = JSON.parse(fs.readFileSync('factbook.json'));
const countrycodes = {};

// Build a hash table of country code to country name
const lines = fs
  .readFileSync('country-3166-1.csv')
  .toString()
  .split('\n');

for (let i = 0; i < lines.length; i++) {
  const parts = lines[i].split(',');
  
  if (parts.length < 2) {
    break;
  }

  let name = parts[1];

  if (name[0] === '"') {
    for (let j = 2; j < parts.length; j++) {
      name += `,${parts[j]}`;
    }
  }

  countrycodes[parts[0]] = name.replace(/"/g, '');
}

function loadGrid(filename) {
  const result = [];
  const lines = fs
    .readFileSync(filename)
    .toString()
    .split('\n');

  for (let i = 0; i < lines.length; i++) {
    result.push(lines[i].split(','));
  }
  
  return result;
}

