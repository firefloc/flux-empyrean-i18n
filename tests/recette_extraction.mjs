import fs from 'node:fs'; import vm from 'node:vm';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const R = new URL('..', import.meta.url).pathname;
const JEU = process.argv[2] || process.env.JEU;
const fzstd = require(R + '/web/vendor/fzstd.js');
const fd = fs.openSync(JEU, 'r');
const fichier = { size: fs.statSync(JEU).size, slice(a, b) {
  const buf = Buffer.alloc(b - a); fs.readSync(fd, buf, 0, b - a, a);
  return { arrayBuffer: async () => buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.length) };
} };
const ctx = { fzstd, TextDecoder, TextEncoder, DataView, Uint8Array, Uint32Array, Map, Set,
  Object, Array, Math, String, Number, JSON, Promise, console, RegExp, Error,
  fetch: async (u) => ({ ok: true, json: async () => JSON.parse(fs.readFileSync(`${R}/web/${u}`, 'utf8')) }) };
vm.createContext(ctx);
vm.runInContext(fs.readFileSync(R + '/web/pack.js', 'utf8'), ctx);
vm.runInContext(fs.readFileSync(R + '/web/extraction.js', 'utf8'), ctx);
const r = await ctx.extraire(fichier, () => {});

const js = new Set();
for (const [c, ss] of r.gel) for (const s of ss) js.add(`${c.replace('\u0000', ' ')} ${s.type} ${s.segment}`);
const py = new Set();
const ref = JSON.parse(fs.readFileSync(R + '/work/frozen_segments.json', 'utf8'));
for (const [d, pp] of Object.entries(ref)) for (const [p, ss] of Object.entries(pp)) for (const s of ss)
  py.add(`${d} ${p} ${s.type} ${s.segment}`);
const manque = [...py].filter((x) => !js.has(x));
const enTrop = [...js].filter((x) => !py.has(x));
console.log(`GEL  JS ${js.size} distincts | Python ${py.size} distincts`);
console.log(`  absents du JS : ${manque.length}`);
manque.forEach((x) => console.log('    -', JSON.stringify(x.slice(0, 90))));
console.log(`  en trop cote JS : ${enTrop.length}`);
enTrop.forEach((x) => console.log('    +', JSON.stringify(x.slice(0, 90))));

const iS = JSON.parse(fs.readFileSync(R + '/web/index/scripts.json', 'utf8'));
let att = 0, got = 0;
for (const [f, l] of Object.entries(iS)) {
  const distinctes = new Set(Object.values(l).flat());
  att += distinctes.size;
  const trouv = new Set(Object.keys(r.scripts[f] || {}));
  got += [...distinctes].filter((e) => trouv.has(e)).length;
  for (const e of distinctes) if (!trouv.has(e)) console.log('    script manquant :', f, e);
}
console.log(`SCRIPTS  ${got}/${att} empreintes distinctes retrouvees`);
