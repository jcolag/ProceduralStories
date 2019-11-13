const fs = require('fs');
const nearestCities = require('find-nearest-cities');

let people = 10;
const population = loadGrid('population_density_deg.csv');
const countries = loadGrid('country_deg.csv');
var skinTones = loadGrid('skintones.csv');
const ciafact = JSON.parse(fs.readFileSync('factbook.json'));
const countrycodes = {};
const skinTonesR = skinTones.reverse().slice(1);
const skinMaxX = Number(skinTonesR[0][0]) + 1;
const skinMaxY = Number(skinTonesR[0][1]) + 1;
const skinRatioX = skinMaxX / countries[0].length;
const skinRatioY = skinMaxY / countries.length;
const skinToneMap = [];

for (stmx = 0; stmx < skinMaxX; stmx++) {
  skinToneMap.push(new Array(skinMaxY));
}

for (pi = 0; pi < skinTonesR.length; pi++) {
  let row = skinTonesR[pi];
  let x = Number(row[0]);
  let y = Number(row[1]);
  let r = Number(row[2]);
  let g = Number(row[3]);
  let b = Number(row[4]);
  
  skinToneMap[y][x] = {
    r: r,
    g: g,
    b: b,
  }
}

if (process.argv.length > 2) {
  people = Number(process.argv[2]);
}

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

if (process.argv.length > 3) {
  maxLat = Number(process.argv[3]);
}

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
  
  if (parts.length < 3) {
    break;
  }

  let name = parts[2];

  if (name[0] === '"') {
    for (let j = 3; j < parts.length; j++) {
      name += `,${parts[j]}`;
    }
  }

  countrycodes[parts[0]] = {
    'numeric': name.replace(/"/g, ''),
    'alpha': parts[1]
  };
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
  const country = countrycodes[ccode].numeric;
  console.log(`${Math.abs(zeroLat - lat)}${ns} ${Math.abs(zeroLong - long)}${ew} : ${country} (${ccode})`);
  const clat = zeroLat - lat + Math.random() - 0.5;
  const clong = long - zeroLong + Math.random() - 0.5;
  const cities = nearestCities(clat, clong).sort((a,b) => a.distance - b.distance);
  cities.forEach(c => {
    console.log(` ${c.name}, ${c.adminCode}, ${c.country} (${c.lat}, ${c.lon}) ${c.distance/1000}km`);
  });
  const key = createCiaKey(country);
  if (ciafact.countries.hasOwnProperty(key)) {
    const people = ciafact.countries[key].data.people;
    const ageList = [];
    Object.keys(people.age_structure).forEach(a => {
      const age = people.age_structure[a];
      if (age.hasOwnProperty('percent')) {
        age.name = a;
        ageList.push(age);
      }
    });
    const age = chooseRandom(ageList);
    const agePeople = age.males + age.females;
    const gender = Math.random() * agePeople <= age.males ? 'Male' : 'Female';
    const religion = chooseRandom(people.religions.religion);
    const ethnic = chooseRandom(people.ethnic_groups.ethnicity);
    console.log(` > ${ciafact.countries[key].data.government.country_name.local_long_form}`);
    console.log(` > ${gender}, age ${age.name.replace(/_/g, ' ')}, ${religion.name} (${religion.percent}%), ${ethnic.name} (${ethnic.percent}%)`);
    const g = gender.toLowerCase();
    if (people.literacy && people.literacy.hasOwnProperty(g)) {
      const lit = people.literacy[g];
      if (lit.units === '%') {
        const r = Math.random() * 100;
        if (r <= lit.value) {
          console.log(' > Literate');
        }
      } else {
        console.log(`-> Found weird units ("${lit.units}")`);
      }
    }
    var languages = ' > Language(s): ';
    people.languages.language.forEach(l => {
      if (Math.random() * 100 <= l.percent) {
        languages += `${l.name} (${l.percent}%), `
      }
    });
    if (languages.length > 16) {
      console.log(languages.replace(/, $/, ''));
    }
  } else {
    console.log(`* * Could not find ${key}`);
  }
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

function chooseRandom(list) {
  var roll = Math.random() * 100;
  var count = -1;
  while (roll > 0) {
    count += 1;
    if (list[count] && list[count].hasOwnProperty('percent')) {
      roll -= list[count].percent;
    } else {
      roll = 0;
    }
  }
  return list[count];
}

function createCiaKey(country) {
  return country
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/ /g, '_')
    .replace(/_/g, '_')
    .replace(/,/g, '')
    .replace(/\(/g, '')
    .replace(/\)/g, '')
    .replace(/_dutch_part/g, '')
    .replace(/_english_part/g, '')
    .replace(/_u.s./g, '')
    .replace(/_of_america/g, '')
    .replace(/malvinas/g, 'islas_malvinas')
    .replace(/myanmar/g, 'burma')
    .replace(/tanzania_united_republic_of/g, 'tanzania')
    .replace(/taiwan_province_of_china/g, 'taiwan')
    .replace(/viet_nam/g, 'vietnam')
    .replace(/iran_islamic_republic_of/g, 'iran')
    .replace(/bahamas/g, 'bahamas_the')
    .replace(/korea_republic_of/g, 'korea_south')
    .replace(/korea_democratic_people's_republic_of/g, 'korea_north')
    .replace(/bolivia_plurinational_state_of/g, 'bolivia')
    .replace(/congo_the_/g, 'congo_')
    .replace(/venezuela_bolivarian_republic_of/g, 'venezuela')
    .replace(/brunei_darussalam/g, 'brunei')
    .replace(/syrian_arab_republic/g, 'syria')
    .replace(/russian_federation/g, 'russia')
    .replace(/virgin_islands_british/g, 'british_virgin_islands')
    .replace(/cote_d'ivoire/g, 'cote_d\'_ivoire')
    .replace(/^congo$/g, 'congo_republic_of_the')
    .replace(/south_georgia_and_the_south_sandwich_islands/g, 'south_georgia_and_south_sandwich_islands')
    .replace(/^gambia$/g, 'gambia_the')
    .replace(/palestine_state_of/g, 'west_bank')
    .replace(/holy_see/g, 'holy_see_vatican_city')
    .replace(/lao_people's_democratic_republic/g, 'laos')
    .replace(/moldova_republic_of/g, 'moldova')
    .replace(/pitcairn/g, 'pitcairn_islands')
    .replace(/guinea-bissau/g, 'guinea_bissau')
    .replace(/timor-leste/g, 'timor_leste')
    .replace(/saint_martin_french_part/g, 'saint_martin')
    .replace(/svalbard_and_jan_mayen/g, 'svalbard')
    .replace(/macedonia_the_former_yugoslav_republic_of/g, 'macedonia')
    ;
}
