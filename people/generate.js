const fs = require('fs');

const population = loadGrid('population_density_deg.csv');
const countries = loadGrid('country_deg.csv');
const ciafact = JSON.parse(fs.readFileSync('factbook.json'));

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

