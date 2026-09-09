// Recette de l'éditeur web dans un vrai navigateur, avec un vrai pack.
//
//   node tests/recette_navigateur.mjs <chemin de l'exécutable du jeu>
//
// Suppose `python3 -m http.server 8731` servi depuis `web/`.
//
// Playwright n'est pas une dépendance du dépôt — il n'y a ici ni `package.json`
// ni `node_modules`, et c'est voulu. Installe-le où tu veux
// (`pnpm add playwright && pnpm exec playwright install firefox`) et pointe
// `PLAYWRIGHT` dessus si ce n'est pas à côté de ce fichier.
import fs from 'node:fs';
import path from 'node:path';

const RACINE = new URL('..', import.meta.url).pathname;
const JEU = process.argv[2] || process.env.JEU;
const BASE = process.env.BASE || 'http://127.0.0.1:8731/';
if (!JEU) {
  console.error("usage : node tests/recette_navigateur.mjs <exécutable du jeu>");
  process.exit(2);
}

const { firefox } = await import(process.env.PLAYWRIGHT || 'playwright');

const navigateur = await firefox.launch();
const page = await navigateur.newPage({ viewport: { width: 1600, height: 1000 } });
const erreurs = [];
page.on('pageerror', (e) => erreurs.push('pageerror: ' + e.message));
page.on('console', (m) => { if (m.type() === 'error') erreurs.push('console: ' + m.text()); });

const recus = new Map();
page.on('download', async (d) => recus.set(d.suggestedFilename(), await d.createReadStream()
  .then((s) => new Promise((r) => { let t = ''; s.on('data', (c) => (t += c)); s.on('end', () => r(t)); }))));

async function deposer(selecteur, fichiers) {
  const chooser = page.waitForEvent('filechooser');
  await page.click(selecteur);
  await (await chooser).setFiles(fichiers);
}

await page.goto(BASE);
// La page ouvre sur l'installeur : c'est le joueur qui compte en premier.
await page.click('#onglet-traduire');

// 1. Ouvrir le jeu et peupler les trois flux.
await deposer('#charger-source', [JEU]);
await page.waitForFunction(() => !document.getElementById('flux').disabled, { timeout: 180000 });
console.log('journal :', (await page.textContent('#journal')).trim());

const attendus = { documents: 601, scenes: 445, scripts: 426 };
for (const [flux, total] of Object.entries(attendus)) {
  await page.selectOption('#flux', flux);
  await page.waitForTimeout(300);
  const compteur = (await page.textContent('#compteur')).trim();
  const lu = Number(compteur.split('/')[1].trim().split(' ')[0]);
  console.log(`  ${flux.padEnd(10)} : ${compteur}${lu === total ? '' : `  ATTENDU ${total}`}`);
}

// 2. Les pages chiffrées sont verrouillées.
await page.selectOption('#flux', 'documents');
await page.fill('#filtre', 'a true plan');
await page.waitForTimeout(300);
const champs = page.locator('#table-zone textarea');
console.log(`pages chiffrées : ${await champs.count()}, dont ` +
            `${await page.locator('#table-zone textarea[readonly]').count()} en lecture seule`);

// 3. Les alertes se lèvent et se retirent.
await page.fill('#filtre', 'immortal');
await page.waitForTimeout(300);
const porteuse = page.locator('#table-zone tr', { hasText: 'immortal' }).first();
const champ = porteuse.locator('textarea');
await champ.fill('Traduction qui perd le mot attendu.');
await page.waitForTimeout(200);
console.log('alerte mot-réponse :', (await porteuse.locator('.probleme').textContent()).trim() || 'AUCUNE');
await champ.fill('Traduction qui garde immortal.');
await page.waitForTimeout(200);
console.log('  une fois remis   :', (await porteuse.locator('.probleme').textContent()).trim() || 'plus d’alerte');
await champ.fill('');
await page.fill('#filtre', '');

// 4. Aller-retour : charger la traduction française, retélécharger, comparer.
//    C'est le contrôle qui compte : une clé recalculée au lieu d'être portée
//    ferait disparaître des traductions sans le moindre message.
const LOCALE = path.join(RACINE, 'locales/fr');
const sources = ['documents.json', 'scenes.json', 'scripts.json'];
await deposer('#charger-langue', sources.map((f) => path.join(LOCALE, f)));
await page.waitForTimeout(1500);
recus.clear();
await page.click('#telecharger');
await page.waitForTimeout(2500);

let ecarts = 0;
for (const nom of sources) {
  const avant = JSON.parse(fs.readFileSync(path.join(LOCALE, nom), 'utf8'));
  const apres = JSON.parse(recus.get(nom) ?? 'null');
  if (apres === null) { console.log(`  ${nom} : NON TÉLÉCHARGÉ`); ecarts++; continue; }
  // Comparaison à plat, chemin par chemin : une clé perdue, une valeur
  // remplacée ou une entrée surgie de nulle part se voient toutes.
  const aplatir = (o, prefixe = '', out = new Map()) => {
    for (const [k, v] of Object.entries(o)) {
      const chemin = prefixe ? `${prefixe} › ${k}` : k;
      if (v && typeof v === 'object') aplatir(v.pages ?? v, chemin, out);
      else out.set(chemin, v);
    }
    return out;
  };
  const a = aplatir(avant.chaines ?? avant);
  const b = aplatir(apres.chaines ?? apres);
  const perdues = [...a.keys()].filter((k) => !b.has(k));
  const surgies = [...b.keys()].filter((k) => !a.has(k));
  const modifiees = [...a.keys()].filter((k) => b.has(k) && b.get(k) !== a.get(k));
  const total = perdues.length + surgies.length + modifiees.length;
  console.log(`  ${nom.padEnd(15)} : ${a.size} → ${b.size} valeurs` +
              (total ? `   ÉCART : ${perdues.length} perdues, ${surgies.length} surgies, ${modifiees.length} modifiées` : ''));
  for (const k of [...perdues, ...surgies, ...modifiees].slice(0, 5)) console.log('     ', k);
  if (total) ecarts++;
}
console.log(ecarts ? `ALLER-RETOUR : ${ecarts} fichier(s) en écart` : 'ALLER-RETOUR : sans perte');

console.log(erreurs.length ? 'ERREURS :\n  ' + erreurs.join('\n  ') : 'aucune erreur de page');
await navigateur.close();
process.exit(ecarts || erreurs.length ? 1 : 0);
