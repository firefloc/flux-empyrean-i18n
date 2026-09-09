// Recette de l'installeur web, dans Chromium.
//
//   node tests/recette_installeur.mjs
//
// Suppose `python3 -m http.server 8731 --directory web` en marche.
//
// `showDirectoryPicker()` ouvre une fenêtre native que rien ne pilote depuis un
// script. On la remplace donc par une doublure de dossier en mémoire, qui
// implémente la même interface. Ça n'exerce pas le sélecteur de Chrome — ça
// exerce tout le reste : détection de plateforme, création de l'arborescence,
// écriture des cinq fichiers, pose du chargeur, et les refus attendus.
import fs from 'node:fs';

const BASE = process.env.BASE || 'http://127.0.0.1:8731/';
const { chromium } = await import(process.env.PLAYWRIGHT || 'playwright');

// La doublure, injectée avant tout script de la page.
const DOUBLURE = (noms) => `
window.__ecrits = {};
function dossier(chemin) {
  return {
    kind: 'directory',
    async *entries() { for (const n of window.__noms) yield [n, { kind: 'file' }]; },
    async getDirectoryHandle(nom) { return dossier(chemin ? chemin + '/' + nom : nom); },
    async getFileHandle(nom) {
      const complet = chemin ? chemin + '/' + nom : nom;
      return {
        async createWritable() {
          return {
            async write(donnees) { window.__ecrits[complet] = donnees.byteLength ?? donnees.length; },
            async close() {},
          };
        },
      };
    },
  };
}
window.__noms = ${JSON.stringify(noms)};
window.showDirectoryPicker = async () => dossier('');
`;

async function scenario(nav, noms, titre) {
  const page = await nav.newPage({ locale: 'fr-FR' });
  const erreurs = [];
  page.on('pageerror', (e) => erreurs.push(e.message));
  page.on('console', (m) => { if (m.type() === 'error') erreurs.push(m.text()); });
  await page.addInitScript(DOUBLURE(noms));
  await page.goto(BASE);
  await page.waitForTimeout(600);

  const bouton = await page.textContent('#install-poser');
  await page.click('#install-poser');
  await page.waitForTimeout(1200);

  const ecrits = await page.evaluate(() => window.__ecrits);
  const journal = (await page.textContent('#install-journal')).trim();
  const suiteVisible = await page.locator('#install-suite').isVisible();
  const plateforme = await page.getAttribute('#install-plateforme', 'data-plateforme');
  const libelle = await page.textContent('#install-plateforme');
  const steamVisible = await page.locator('#install-steam').isVisible();
  const protonVisible = await page.locator('#install-proton').isVisible();

  console.log(`\n── ${titre}`);
  console.log(`   bouton      : ${bouton}`);
  console.log(`   plateforme  : ${plateforme || '(aucune)'}  « ${libelle} »`);
  console.log(`   étapes 3/4  : suite ${suiteVisible ? 'affichée' : 'masquée'}, ` +
              `Steam ${steamVisible ? 'affiché' : 'masqué'}, ` +
              `Proton ${protonVisible ? 'affiché' : 'masqué'}`);
  console.log(`   écrits      : ${Object.keys(ecrits).length} fichier(s)`);
  for (const [chemin, taille] of Object.entries(ecrits)) {
    console.log(`      ${chemin}  ${taille} o`);
  }
  console.log(`   journal     : ${journal.slice(0, 100)}`);
  if (erreurs.length) console.log(`   ERREURS     : ${erreurs.join(' | ')}`);
  await page.close();
  return { ecrits, journal, plateforme, steamVisible, protonVisible, erreurs };
}

const nav = await chromium.launch();
let echecs = 0;
const verifier = (condition, message) => {
  if (!condition) { console.log(`   ✗ ${message}`); echecs++; }
};

// 1. Un dossier de jeu Linux.
const linux = await scenario(nav, ['flux-empyrean.x86_64', 'libsteam_api.so'], 'dossier Linux');
verifier(linux.plateforme === 'linux', 'plateforme mal détectée');
// Cinq fichiers de mod, plus le lanceur que la page écrit à la racine : sans
// lui, un joueur Linux devrait aller chercher un script ailleurs et lui donner
// le droit d'exécution, que le navigateur ne peut pas accorder.
verifier(Object.keys(linux.ecrits).length === 6, '5 fichiers de mod + le lanceur');
verifier(
  Object.keys(linux.ecrits).filter((c) => c.startsWith('GDPatch/mods/flux_fr/')).length === 5,
  'les cinq fichiers du mod sous GDPatch/mods/flux_fr/'
);
const LANCEUR_ATTENDU = fs.statSync(new URL('../web/vendor/run_with_gdpatch.sh', import.meta.url)).size;
verifier('run_with_gdpatch.sh' in linux.ecrits, 'le lanceur Linux doit être écrit');
verifier(
  linux.ecrits['run_with_gdpatch.sh'] === LANCEUR_ATTENDU,
  `le lanceur doit être le script officiel servi depuis vendor/ (${LANCEUR_ATTENDU} o)`
);
verifier(!('lancer_avec_gdpatch.sh' in linux.ecrits), 'plus de lanceur maison');
verifier(linux.steamVisible, 'la ligne Steam doit être affichée sous Linux');
verifier(!linux.protonVisible, 'pas de consigne Proton pour un jeu Linux natif');
verifier(/manque le chargeur/.test(linux.journal), 'le chargeur absent doit être signalé');
verifier(linux.erreurs.length === 0, 'aucune erreur de page attendue');

// 2. Un dossier de jeu Windows, chargeur déjà en place.
const windows = await scenario(
  nav, ['Flux Empyrean.exe', 'winmm.dll'], 'dossier Windows, chargeur en place sous son vrai nom'
);
verifier(windows.plateforme === 'windows', 'plateforme mal détectée');
// Sous Windows le lanceur n'a pas lieu d'être : la DLL se branche seule.
verifier(Object.keys(windows.ecrits).length === 5, '5 fichiers, sans lanceur');
verifier(!('run_with_gdpatch.sh' in windows.ecrits), 'pas de lanceur sous Windows');
verifier(!windows.steamVisible, 'pas de ligne Steam sous Windows');
verifier(windows.protonVisible, 'la consigne Proton doit être affichée sous Windows');
verifier(/en place/.test(windows.journal), 'le chargeur présent doit être reconnu');
verifier(windows.erreurs.length === 0, 'aucune erreur de page attendue');

// 3. Un dossier qui n'est pas celui du jeu : on refuse, sans rien écrire.
const mauvais = await scenario(nav, ['Documents', 'photo.jpg'], 'mauvais dossier');
verifier(Object.keys(mauvais.ecrits).length === 0, 'rien ne doit être écrit');
verifier(/ne ressemble pas/.test(mauvais.journal), 'le refus doit être expliqué');

await nav.close();
console.log(echecs ? `\n${echecs} contrôle(s) en échec` : '\nRECETTE INSTALLEUR : tout passe');
process.exit(echecs ? 1 : 0);
