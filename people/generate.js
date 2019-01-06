const fs = require('fs');
const nearestCities = require('find-nearest-cities');

let people = 10;
const population = loadGrid('population_density_deg.csv');
const countries = loadGrid('country_deg.csv');
const ciafact = JSON.parse(fs.readFileSync('factbook.json'));
const countrycodes = {};

// For countries, row 135 appears to map to 55S latitude, based on
// there being Australian territory, which would be the Bishop and
// Clerk Islets.
// Row 139 lists country 906, which isn't on the ISO 3166-1 list,
// but since that would be around 59S and southest of South America,
// they must be South Georgia and the South Sandwich Islands, which
// matches the crescent shape, and Southern Thule indeed has latitudes
// at 59S.
// That sets the equator to row 80.

// For populations, the last row is 135, which represents the
// southernmost parts of South America.  Conveniently, both maps
// run that line from the 109th column to the 114th, so the two
// maps do match.

// Based on visual inspection, specifically the location of Oran,
// Algeria, the 179th column appears to be the Prime Meridian.  And
// 80x179 looks a lot like where one would expect Null Island.

const zeroLat = 80;
const zeroLong = 179;

// We may want to ignore the upper latitudes for some projects.
let maxLat = 80;

let lat = 0;
let long = 0;

// Build a hash table of country code to country name
// Note that the following territories have assigned ISO
// country codes and those codes are listed on the
// SEDAC country map, but do NOT appear in the CIA World
// Factbook at this time, because they are not (or are
// not recognized as) independent nations:
//  * Åland Islands (autonomous region of Finland)
//  * Bonaire, Sint Eustatius and Saba (under Dutch control)
//  * French Guiana (under French control)
//  * Guadeloupe (under French control)
//  * Martinique (under French control)
//  * Mayotte (under French control)
//  * Réunion (under French control)
// In addition, the French Southern Territories and United
// States Minor Outlying Islands both have country codes, but
// do not appear elsewhere in the data.
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

// Count up the total population listed on the map
let total = 0;

for (lat = zeroLat - maxLat; lat < population.length; lat++) {
  for (long = 0; long < population[lat].length; long++) {
    const n = new Number(population[lat][long]);
    if (!isNaN(n)) {
      total += n;
    }
  }
}

for (var person = 0; person < people; person++) {
  let index = Math.random() * total;
  let count = 0;
  let found = false;

  // This is more or less a Markov process with one step and
  // no context:  Pick a random number (index) and subtract
  // graticule populations until we've seen more people than
  // the random number.
  for (i = zeroLat - maxLat; i < population.length; i++) {
    for (let j = 0; j < population[i].length; j++) {
      const n = new Number(population[i][j]);
      if (!isNaN(n)) {
        count += n;
        if (count > index) {
          lat = i;
          long = j;
          found = true;
          break;
        }
      }
    }

    if (found) {
      break;
    }
  }

  // Convert the row and column to a latitude, longitude, and
  // country
  const ns = zeroLat > lat ? 'N' : 'S';
  const ew = zeroLong > long ? 'W' : 'E';
  const ccode = countries[lat][long];
  const country = countrycodes[ccode];
  console.log(`${Math.abs(zeroLat - lat)}${ns} ${Math.abs(zeroLong - long)}${ew} : ${country} (${ccode})`);
  const clat = zeroLat - lat + Math.random() - 0.5;
  const clong = long - zeroLong + Math.random() - 0.5;
  const cities = nearestCities(clat, clong).sort((a,b) => a.distance - b.distance);
  cities.forEach(c => {
    console.log(` ${c.name}, ${c.adminCode}, ${c.country} (${c.lat}, ${c.lon}) ${c.distance/1000}km`);
  });
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

