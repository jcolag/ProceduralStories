const mutate_iron = [
  { orig: 'son\\b', active: false, index: 0, options: [ 'ziion' ], },
  { orig: 'ary\\b', active: false, index: 0, options: [ 'ik' ], },
  { orig: '\\bh', active: false, index: 0, options: [ '' ], },
  { orig: 'e\\b', active: false, index: 0, options: [ 'a' ], },
  { orig: 'cted\\b', active: false, index: 0, options: [ 'k' ], },
  { orig: 'tion\\b', active: false, index: 0, options: [ 'zon' ], },
  { orig: 'p\\b', active: false, index: 0, options: [ 'pen' ], },
  { orig: 'd\\b', active: false, index: 0, options: [ 'a' ], },
  { orig: '\\bthe\\b', active: false, index: 0, options: [ 'din' ], },
  { orig: 'g', active: false, index: 0, options: [ 'z' ], },
  { orig: 'cy\\b', active: false, index: 0, options: [ 'ciskija' ], },
  { orig: 'tch', active: false, index: 0, options: [ 'chin' ], },
  { orig: 'tt', active: false, index: 0, options: [ 't' ], },
  { orig: '\\bno\\b', active: false, index: 0, options: [ 'net' ], },
  { orig: 's\\b', active: false, index: 0, options: [ 'en', 'z' ], },
  { orig: 'or', active: false, index: 0, options: [ 'er' ], },
  { orig: 'k\\b', active: false, index: 0, options: [ 'ke' ], },
  { orig: 'th', active: false, index: 0, options: [ 'd' ], },
  { orig: 'w', active: false, index: 0, options: [ 'qqqq' ], },
  { orig: 'v', active: false, index: 0, options: [ 'w' ], },
  { orig: 'qqqq', active: false, index: 0, options: [ 'v' ], },
  { orig: 'ment', active: false, index: 0, options: [ 'gung' ], },
  { orig: 'ain', active: false, index: 0, options: [ 'ahr' ], },
];
const mutate_rom = [
  { orig: 'air', active: false, index: 0, options: [ 'aration' ], },
  { orig: 'c\\b', active: false, index: 0, options: [ 'que' ], },
  { orig: '\\band\\b', active: false, index: 0, options: [ 'et' ], },
  { orig: 'eas', active: false, index: 0, options: [ 'e' ], },
  { orig: 'om', active: false, index: 0, options: [ 'ane' ], },
  { orig: 'ce\\b', active: false, index: 0, options: [ 'caise' ], },
];
const mutations = mutate_iron;
let plain = process.argv
  .slice(2)
  .join(' ')
  .normalize('NFD');
let output = '';
plain = mutateString(plain);
for (let i = 0; i < plain.length; i++) {
  const c = plain[i];
  output += c;
  if (c.match(/[a-z]/i)) {
    const rLen = Math.floor(Math.log2(Math.random() * 3));
    for (j = 0; j < rLen; j++) {
      const rCh = 0x0300 + Math.floor(Math.random() * 0x006f);
      output += String.fromCharCode(rCh);
    }
  }
}

console.log(output.normalize("NFC"));

function mutateString(text) {
  let result = text;
  mutations.forEach(m => {
    if (Math.random() > 0) {
      m.active = true;
      m.index = Math.floor(Math.random() * m.options.length);
    }
    
    if (m.active) {
      const re = new RegExp(m.orig, "gi");
      result = result.replace(re, match => keepCase(m.options[m.index], match));
    }
  });
  return result;
}

function keepCase(text, pattern) {
  if (text === '') {
    return '';
  }
  const init = pattern[0];
  let result = init.match(/[A-Z]/) ? text[0].toUpperCase() : text[0];
  return result + text.slice(1);
}
