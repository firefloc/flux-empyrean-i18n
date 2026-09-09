// L'interface du site, dans la langue du visiteur.
//
// Un outil de traduction qui ne parle qu'une langue, c'est une contradiction.
// Le site suit donc `navigator.language`, retombe sur l'anglais s'il ne connaît
// pas, et laisse changer à la main — le choix est retenu dans le navigateur.
//
// Les textes vivent ici plutôt que dans le HTML : c'est un fichier à traduire,
// pas des balises à recopier. Une contribution nouvelle langue tient dans un
// objet ajouté à `TEXTES`, et rien d'autre ne bouge.
//
// L'anglais est la référence : une clé absente d'une traduction retombe dessus
// plutôt que d'afficher son propre nom, qui ne renseignerait personne.

// Les textes vivent dans `ui/<code>.json`, pas ici. C'est un fichier de langue
// comme les autres : le traduire est une pull request sur du JSON, pas une
// modification de code. On ne charge que la langue active et l'anglais, qui
// sert de filet quand une clé manque.

const TEXTES = { en: {}, fr: {} };

// Les langues dans lesquelles l'interface existe. Une de plus, c'est un fichier
// `ui/<code>.json` et une ligne ici.
const LANGUES_UI = {
  en: "English", fr: "Français", de: "Deutsch", es: "Español", it: "Italiano",
  nl: "Nederlands", "pt-BR": "Português (BR)", pl: "Polski", ru: "Русский",
  uk: "Українська", tr: "Türkçe", ja: "日本語", ko: "한국어", "zh-Hans": "简体中文",
};
const CLE_LANGUE_UI = "flux-empyrean:langue-ui";

// Les navigateurs annoncent des codes régionaux qui ne portent pas le nom de nos
// fichiers : « zh-CN » est du chinois simplifié, « pt-PT » du portugais qu'un
// lecteur brésilien comprendra mieux que de l'anglais. Sans cette table, ces
// visiteurs tombaient sur l'anglais alors qu'on avait leur langue.
const EQUIVALENCES = {
  zh: "zh-Hans", "zh-CN": "zh-Hans", "zh-SG": "zh-Hans", "zh-Hans-CN": "zh-Hans",
  pt: "pt-BR", "pt-PT": "pt-BR",
};
// Deux replis assumés, pas des équivalences : « zh-TW » et « zh-HK » sont du
// chinois traditionnel et retombent ici sur le simplifié, « pt-PT » sur le
// portugais du Brésil. C'est plus lisible que l'anglais, sans être juste — un
// fichier ui/zh-Hant.json ou ui/pt-PT.json corrigerait ça, et il manque.

function langueChoisie() {
  const retenue = localStorage.getItem(CLE_LANGUE_UI);
  if (retenue && LANGUES_UI[retenue]) return retenue;
  // `navigator.languages` est classé par préférence : on prend la première
  // qu'on sait parler, sur sa base — « fr-CA » doit donner « fr ».
  for (const demandee of navigator.languages || [navigator.language || "en"]) {
    // « pt-BR » d'abord tel quel, puis « pt » : les variantes régionales n'ont
    // pas toutes leur fichier, mais certaines en ont un et sont distinctes.
    const exacte = String(demandee);
    if (LANGUES_UI[exacte]) return exacte;
    if (EQUIVALENCES[exacte]) return EQUIVALENCES[exacte];
    const base = exacte.split("-")[0];
    if (LANGUES_UI[base]) return base;
    if (EQUIVALENCES[base]) return EQUIVALENCES[base];
  }
  return "en";
}

/** Charge un fichier de langue, une seule fois. */
async function charger(code) {
  if (Object.keys(TEXTES[code] || {}).length) return;
  try {
    const reponse = await fetch(`ui/${code}.json`, { cache: "no-store" });
    if (reponse.ok) TEXTES[code] = await reponse.json();
  } catch {
    // L'anglais reste, et il suffit à comprendre la page.
  }
}

let LANGUE = langueChoisie();

// Les noms de fichiers reviennent dans plusieurs textes et ne se traduisent
// pas. Les laisser en clair dans chaque langue, c'est douze occasions de se
// tromper à la prochaine renommée — et ils s'affichaient tels quels, entre
// accolades, faute d'être fournis à l'application automatique.
const CONSTANTES = {
  so: "libgdpatch_loader.so",
  dll: "gdpatch_loader.dll",
  linux: "flux-empyrean.x86_64",
  windows: "Flux Empyrean.exe",
  gdpatch: "GDPatch/",
  data: "GDPatch/mods/flux_<langue>/data/",
};

/** Un texte de l'interface, avec ses trous remplis. L'anglais sert de filet. */
function t(cle, valeurs = {}) {
  const brut = TEXTES[LANGUE]?.[cle] ?? TEXTES.en[cle] ?? cle;
  const remplis = { ...CONSTANTES, ...valeurs };
  return brut.replace(/\{(\w+)\}/g, (entier, nom) =>
    nom in remplis ? String(remplis[nom]) : entier
  );
}

/** Applique la langue à tout ce que le HTML a marqué. */
function appliquerLangue() {
  document.documentElement.lang = LANGUE;
  document.title = t("page.titre");
  for (const el of document.querySelectorAll("[data-t]")) {
    el.textContent = t(el.dataset.t);
  }
  for (const el of document.querySelectorAll("[data-t-placeholder]")) {
    el.placeholder = t(el.dataset.tPlaceholder);
  }
  for (const el of document.querySelectorAll("[data-t-title]")) {
    el.title = t(el.dataset.tTitle);
  }
  // Une traduction d'interface produite par machine et jamais relue par un
  // humain doit se signaler. Le projet demande la même honnêteté à la
  // traduction du jeu ; il la doit à la sienne.
  const avis = document.getElementById("langue-avis");
  if (avis) {
    const relue = TEXTES[LANGUE]?._revue_humaine;
    avis.hidden = LANGUE === "en" || relue !== false;
    avis.textContent = avis.hidden ? "" : t("ui.non_relue");
  }
  document.dispatchEvent(new CustomEvent("langue-changee"));
}

async function changerLangue(code) {
  if (!LANGUES_UI[code]) return;
  await charger(code);
  LANGUE = code;
  localStorage.setItem(CLE_LANGUE_UI, code);
  appliquerLangue();
}

/** À l'ouverture : l'anglais comme filet, puis la langue du visiteur. */
async function demarrerI18n() {
  await charger("en");
  if (LANGUE !== "en") await charger(LANGUE);
  appliquerLangue();
}
