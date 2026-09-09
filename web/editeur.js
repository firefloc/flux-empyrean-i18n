// Éditeur de traduction — page statique, sans serveur ni collecte.
//
// Le texte anglais ne vient jamais du dépôt : il est lu dans le pack de la
// copie du joueur, ici, dans son navigateur. Rien n'est téléversé. C'est ce qui
// permet de publier l'outil sans redistribuer l'œuvre de son auteur : le dépôt
// n'embarque que `index/`, des nombres de pages et des empreintes.
//
// Les garde-fous reproduits ici sont une commodité de saisie. L'autorité reste
// `tools/verify_locale.py`, rejoué par l'intégration continue sur chaque PR.

// À renseigner au moment de la publication. Tant que c'est vide, le bouton de
// contribution explique la marche à suivre au lieu d'ouvrir un lien mort.
const DEPOT = "";

const etat = {
  source: { documents: null, scenes: null, scripts: null },
  geles: null,
  verrous: null,
  langue: { documents: {}, scenes: {}, scripts: {}, aliases: {} },
  codeLangue: "fr",
  flux: "documents",
  filtre: "",
  restantsSeuls: false,
};

const $ = (id) => document.getElementById(id);

// --- Brouillon local ---------------------------------------------------------
//
// Traduire 601 pages ne se fait pas d'une traite. Sans mémoire, fermer l'onglet
// perdait tout — et il n'y a pas de serveur pour rattraper ça. Le navigateur
// garde donc le travail en cours, par langue, sur la machine du contributeur.
//
// On enregistre aussi le texte anglais extrait, pour ne pas avoir à redésigner
// le fichier du jeu à chaque reprise. C'est la copie du joueur, dans son propre
// navigateur : elle n'en sort pas plus que le reste.

const CLE_BROUILLON = "flux-empyrean:brouillon";
const CLE_SOURCE = "flux-empyrean:source";

function enregistrer() {
  try {
    localStorage.setItem(CLE_BROUILLON, JSON.stringify({
      code: etat.codeLangue,
      quand: Date.now(),
      langue: etat.langue,
    }));
    marquerEnregistrement();
  } catch (e) {
    // Quota dépassé : on le dit plutôt que de laisser croire que c'est sauvé.
    $("brouillon").textContent = t("brouillon.plein");
    $("brouillon").style.color = "var(--erreur)";
  }
}

let minuterie = null;
function enregistrerBientot() {
  clearTimeout(minuterie);
  minuterie = setTimeout(enregistrer, 800);
}

function marquerEnregistrement() {
  const zone = $("brouillon");
  zone.style.color = "var(--attenue)";
  zone.textContent = t("brouillon.enregistre", {
    heure: new Date().toLocaleTimeString(LANGUE, { hour: "2-digit", minute: "2-digit" }),
  });
}

function brouillonEnregistre() {
  try {
    const brut = localStorage.getItem(CLE_BROUILLON);
    return brut ? JSON.parse(brut) : null;
  } catch {
    return null;
  }
}

function enregistrerSource(extrait) {
  try {
    localStorage.setItem(CLE_SOURCE, JSON.stringify({
      moteur: extrait.moteur,
      nombreDeFichiers: extrait.nombreDeFichiers,
      documents: extrait.documents,
      scenes: extrait.scenes,
      scripts: extrait.scripts,
      gel: [...extrait.gel],
      verrous: extrait.verrous,
    }));
  } catch {
    // Tant pis : le contributeur redésignera son jeu. Le brouillon, lui, tient.
  }
}

function sourceEnregistree() {
  try {
    const brut = localStorage.getItem(CLE_SOURCE);
    if (!brut) return null;
    const lu = JSON.parse(brut);
    lu.gel = new Map(lu.gel);
    return lu;
  } catch {
    return null;
  }
}

function oublier() {
  localStorage.removeItem(CLE_BROUILLON);
  localStorage.removeItem(CLE_SOURCE);
}

/** Choisit des fichiers et les rend décodés en JSON, indexés par nom. */
function choisirFichiers(multiple = true) {
  return new Promise((resolve) => {
    const input = document.createElement("input");
    input.type = "file";
    input.accept = ".json";
    input.multiple = multiple;
    input.onchange = async () => {
      const out = {};
      for (const f of input.files) {
        try {
          out[f.name] = JSON.parse(await f.text());
        } catch (e) {
          alert(`${f.name} : JSON illisible — ${e.message}`);
        }
      }
      resolve(out);
    };
    input.click();
  });
}

function choisirJeu() {
  return new Promise((resolve) => {
    const input = document.createElement("input");
    input.type = "file";
    input.onchange = () => resolve(input.files[0] || null);
    input.click();
  });
}

/** Met l'extraction du pack à la forme que l'éditeur manipule. */
function adopter(extrait) {
  etat.source.documents = Object.fromEntries(extrait.documents.map((d) => [d.titre, d.pages]));

  etat.source.scenes = {};
  for (const [scene, noeuds] of Object.entries(extrait.scenes)) {
    etat.source.scenes[scene] = Object.fromEntries(
      Object.entries(noeuds).map(([noeud, v]) => [noeud, v.texte])
    );
  }

  // On garde l'empreinte que l'extraction a déjà résolue, au lieu de la
  // recalculer plus tard. Quatre chaînes s'écrivent autrement dans la source
  // décompilée que dans le pack : les ré-empreinter donnerait une clé que
  // l'outillage Python ne sait pas résoudre, et leur traduction se perdrait
  // sans un mot.
  etat.source.scripts = {};
  for (const [script, parEmpreinte] of Object.entries(extrait.scripts)) {
    const parLigne = {};
    for (const [cle, { texte, ligne }] of Object.entries(parEmpreinte)) {
      (parLigne[ligne] ||= []).push({ texte, empreinte: cle });
    }
    etat.source.scripts[script] = parLigne;
  }

  etat.geles = {};
  for (const [cle, segments] of extrait.gel) {
    // `clePage` joint le titre et le rang par un octet nul.
    const [titre, page] = cle.split("\u0000");
    (etat.geles[titre] ||= {})[page] = segments;
  }

  etat.verrous = extrait.verrous;
}

$("charger-source").onclick = async () => {
  const fichier = await choisirJeu();
  if (!fichier) return;
  const journal = $("journal");
  journal.hidden = false;
  const dire = (m) => (journal.textContent = m);
  try {
    dire("ouverture du pack…");
    const extrait = await extraire(fichier, dire);
    adopter(extrait);
    enregistrerSource(extrait);

    const documents = extrait.documents.length;
    const pages = extrait.documents.reduce((n, d) => n + d.pages.length, 0);
    const chainesScenes = Object.values(extrait.scenes).reduce((n, o) => n + Object.keys(o).length, 0);
    const chainesCode = Object.values(extrait.scripts).reduce((n, o) => n + Object.keys(o).length, 0);
    // Le jeu complet porte 167 documents. La démo en porte nettement moins ;
    // c'est ce qui distingue les deux, pas un contrôle de licence.
    const complet = documents >= 160;
    dire(
      `Godot ${extrait.moteur} · ${extrait.nombreDeFichiers} fichiers · ` +
      `${documents} documents (${pages} pages), ${chainesScenes} chaînes de scène, ` +
      `${chainesCode} chaînes de code` +
      (complet ? "" : " — corpus incomplet : c'est probablement la démo, la traduction sera partielle.")
    );
    journal.style.color = complet ? "var(--attenue)" : "var(--alerte)";

    $("intro").style.display = "none";
    for (const id of ["charger-langue", "charger-publiee", "flux", "filtre",
                      "telecharger", "contribuer", "code-langue"]) {
      $(id).disabled = false;
    }
    dessiner();
  } catch (e) {
    journal.style.color = "var(--erreur)";
    dire(`Lecture impossible : ${e.message}`);
  }
};

// Les traductions publiées sur la page, proposées directement. Un contributeur
// qui veut améliorer le français n'a pas à aller chercher trois fichiers : il
// choisit la langue et elle se charge.
async function languesPubliees() {
  try {
    const reponse = await fetch("releases/manifeste.json", { cache: "no-store" });
    if (!reponse.ok) return [];
    return (await reponse.json()).langues.filter((l) => l.editable);
  } catch {
    return [];
  }
}

async function chargerLanguePubliee(code) {
  const fichiers = ["documents.json", "scenes.json", "scripts.json", "aliases.json"];
  const lus = {};
  for (const nom of fichiers) {
    const reponse = await fetch(`locales/${code}/${nom}`);
    if (!reponse.ok) throw new Error(`locales/${code}/${nom} absent de la page`);
    lus[nom] = await reponse.json();
  }
  etat.langue.documents = lus["documents.json"];
  etat.langue.scenes = lus["scenes.json"].chaines ?? lus["scenes.json"];
  etat.langue.scripts = relireScripts(lus["scripts.json"].chaines ?? lus["scripts.json"]);
  etat.langue.aliases = lus["aliases.json"] ?? {};
  etat.codeLangue = code;
  $("code-langue").value = code;
  dessiner();
}

$("charger-langue").onclick = async () => {
  const fichiers = await choisirFichiers();
  for (const [nom, data] of Object.entries(fichiers)) {
    if (nom.startsWith("documents")) etat.langue.documents = data;
    else if (nom.startsWith("scenes")) etat.langue.scenes = data.chaines || data;
    else if (nom.startsWith("scripts")) etat.langue.scripts = relireScripts(data.chaines || data);
  }
  dessiner();
};

// `scripts.json` est publié indexé par empreinte, et c'est aussi la clé que
// l'éditeur manipule : il n'y a rien à recalculer. Seuls les fichiers anciens,
// encore indexés par le texte anglais, demandent une conversion.
function relireScripts(parCle) {
  const sortie = {};
  for (const [script, paires] of Object.entries(parCle)) {
    for (const [cle, valeur] of Object.entries(paires)) {
      (sortie[script] ||= {})[cle.startsWith("#") ? cle : empreinte(cle)] = valeur;
    }
  }
  return sortie;
}

$("charger-publiee").onchange = async (e) => {
  const code = e.target.value;
  if (!code) return;
  const journal = $("journal");
  journal.hidden = false;
  try {
    journal.style.color = "var(--attenue)";
    journal.textContent = `chargement de la traduction « ${code} »…`;
    await chargerLanguePubliee(code);
    journal.textContent =
      `Traduction « ${code} » chargée. Corrige ce que tu veux, puis propose-la au projet.`;
  } catch (err) {
    journal.style.color = "var(--erreur)";
    journal.textContent = err.message;
  }
};

$("flux").onchange = (e) => { etat.flux = e.target.value; dessiner(); };
$("filtre").oninput = (e) => { etat.filtre = e.target.value.toLowerCase(); dessiner(); };
$("restants").onchange = (e) => { etat.restantsSeuls = e.target.checked; dessiner(); };
$("code-langue").oninput = (e) => { etat.codeLangue = e.target.value.trim() || "fr"; };

/** Les segments gelés d'une page de document, s'il y en a. */
function segmentsGeles(titre, page) {
  return (etat.geles?.[titre]?.[String(page)] || []).map((s) => s.segment);
}

/** Les mots-réponses qu'un document est censé enseigner. */
function verrousDe(titre) {
  // Plusieurs points de saisie peuvent viser le même document et le même mot ;
  // on ne veut pas afficher l'avertissement deux fois.
  const out = new Set();
  for (const point of etat.verrous?.points_de_saisie || []) {
    const acrostiches = point.tokens_par_acrostiche || [];
    for (const [token, sources] of Object.entries(point.documents_source || {})) {
      if (Array.isArray(sources) && sources.includes(titre) && !acrostiches.includes(token)) {
        out.add(token);
      }
    }
  }
  return [...out];
}

/** Les lignes du flux courant, sous forme homogène. */
function lignes() {
  const out = [];
  if (etat.flux === "documents") {
    for (const [titre, pages] of Object.entries(etat.source.documents)) {
      const cible = etat.langue.documents[titre]?.pages || [];
      const verrous = verrousDe(titre);
      pages.forEach((anglais, i) => {
        const geles = segmentsGeles(titre, i);
        out.push({
          cle: `${titre}|${i}`, groupe: titre, index: i,
          anglais, cible: cible[i] ?? "", geles, verrous,
        });
      });
    }
  } else if (etat.flux === "scenes") {
    for (const [scene, entrees] of Object.entries(etat.source.scenes)) {
      for (const [index, anglais] of Object.entries(entrees)) {
        out.push({
          cle: `${scene}|${index}`, groupe: scene.split("/").pop(), index,
          anglais, cible: etat.langue.scenes[scene]?.[index] ?? "", geles: [], verrous: [],
        });
      }
    }
  } else {
    for (const [script, parLigne] of Object.entries(etat.source.scripts)) {
      for (const chaines of Object.values(parLigne)) {
        for (const { texte, empreinte: cle } of chaines) {
          out.push({
            cle: `${script}|${cle}`, groupe: script.split("/").pop(), index: "",
            anglais: texte, cible: etat.langue.scripts[script]?.[cle] ?? "",
            geles: [], verrous: [], script, empreinteSource: cle,
          });
        }
      }
    }
  }
  return out;
}

/** Les problèmes d'une ligne — les mêmes règles que verify_locale.py. */
function problemes(l) {
  const out = [];
  if (!l.cible) return out;
  for (const seg of l.geles) {
    if (!l.cible.includes(seg)) {
      out.push(`segment gelé altéré : « ${seg.slice(0, 40)}… » doit être recopié à l'identique`);
    }
  }
  for (const token of l.verrous) {
    const dansAnglais = l.anglais.toLowerCase().includes(token.toLowerCase());
    if (!dansAnglais) continue;
    const cible = l.cible.toLowerCase();
    if (cible.includes(token.toLowerCase())) continue;
    // Le mot anglais peut disparaître sans casser l'énigme : le mod patche la
    // comparaison pour accepter les équivalents déclarés dans `aliases.json`.
    // Ne pas le savoir, c'est crier sur une traduction correcte — et pousser
    // quelqu'un à « réparer » ce qui marche.
    const equivalents = etat.langue.aliases?.[token] || [];
    if (equivalents.some((e) => cible.includes(String(e).toLowerCase()))) continue;
    out.push(
      `le mot-réponse « ${token} » a disparu, et aucun de ses équivalents n'est là : ` +
      "ajoute-en un dans aliases.json, sinon l'énigme ne se résoudra qu'en anglais"
    );
  }
  if (etat.flux === "scripts") {
    if (l.cible.includes('"')) out.push("guillemet droit interdit ici — emploie « » ou ’");
    if (l.cible.includes("\n")) out.push("saut de ligne brut interdit ici");
    const marqueurs = (s) => (s.match(/%[sdv]/g) || []).length;
    if (marqueurs(l.anglais) !== marqueurs(l.cible)) {
      out.push(`marqueurs %s/%d : ${marqueurs(l.cible)} au lieu de ${marqueurs(l.anglais)}`);
    }
  }
  return out;
}

function memoriser(l, valeur) {
  if (etat.flux === "documents") {
    const titre = l.cle.slice(0, l.cle.lastIndexOf("|"));
    const source = etat.source.documents[titre];
    const entree = (etat.langue.documents[titre] ||= { pages: source.map(() => "") });
    if (!Array.isArray(entree.pages) || entree.pages.length !== source.length) {
      entree.pages = source.map((_, i) => entree.pages?.[i] ?? "");
    }
    entree.pages[l.index] = valeur;
  } else if (etat.flux === "scenes") {
    const scene = l.cle.slice(0, l.cle.lastIndexOf("|"));
    (etat.langue.scenes[scene] ||= {})[l.index] = valeur;
  } else {
    (etat.langue.scripts[l.script] ||= {})[l.empreinteSource] = valeur;
  }
}

function dessiner() {
  const toutes = lignes();
  const visibles = toutes.filter((l) => {
    if (etat.restantsSeuls && l.cible) return false;
    if (!etat.filtre) return true;
    return (l.groupe + " " + l.anglais + " " + l.cible).toLowerCase().includes(etat.filtre);
  });

  dessinerCompteur(toutes);

  const zone = $("table-zone");
  zone.textContent = "";
  if (!visibles.length) {
    const vide = document.createElement("p");
    vide.className = "vide";
    vide.textContent = t("trad.vide");
    zone.appendChild(vide);
    return;
  }

  const table = document.createElement("table");
  const entete = document.createElement("thead");
  const ligneEntete = document.createElement("tr");
  for (const libelle of [t("trad.colonne.original"), t("trad.colonne.traduction"),
                         t("trad.colonne.etat")]) {
    const th = document.createElement("th");
    th.textContent = libelle;
    ligneEntete.appendChild(th);
  }
  entete.appendChild(ligneEntete);
  table.appendChild(entete);
  const corps = document.createElement("tbody");

  // Tout est affiché. Le plafond de 400 lignes était une prudence inutile — le
  // corpus entier fait 601 pages, et la saisie ne redessine que sa propre ligne.
  // Le cacher forçait à filtrer pour voir la fin du corpus, ce qui est exactement
  // le contraire de ce qu'on demande à un relecteur.
  let groupeCourant = null;
  for (const l of visibles) {
    if (l.groupe !== groupeCourant) {
      groupeCourant = l.groupe;
      const sep = document.createElement("tr");
      const cell = document.createElement("td");
      cell.colSpan = 3;
      cell.className = "groupe";
      // textContent, jamais innerHTML : ces libellés viennent des fichiers du
      // joueur, on ne les interprète pas comme du balisage.
      cell.textContent = l.groupe;
      sep.appendChild(cell);
      corps.appendChild(sep);
    }
    const tr = document.createElement("tr");
    const pageEntiereGelee = l.geles.length && l.geles.join("") === l.anglais.replace(/\s/g, "");
    if (l.geles.length) tr.className = "gele";

    const tdSource = document.createElement("td");
    tdSource.className = "source";
    tdSource.textContent = l.anglais;

    const tdCible = document.createElement("td");
    tdCible.className = "cible";
    const zoneTexte = document.createElement("textarea");
    zoneTexte.value = l.cible;
    // La hauteur suit le nombre de lignes réellement rendues à gauche, pas une
    // estimation : sans ça, les deux colonnes ne s'alignent jamais.
    const lignesSource = l.anglais.split("\n").length +
      Math.floor(l.anglais.length / 62);
    zoneTexte.rows = Math.min(14, Math.max(2, lignesSource));
    if (pageEntiereGelee) {
      zoneTexte.readOnly = true;
      zoneTexte.value = l.anglais;
      memoriser(l, l.anglais);
      zoneTexte.title =
        "Bloc chiffré ou langue construite : le jeu le déchiffre lettre à lettre. " +
        "Une seule lettre changée rend l'énigme insoluble, donc il est recopié tel quel.";
      tr.classList.add("figee");
    }
    const alerte = document.createElement("div");
    alerte.className = "probleme";
    const rafraichir = () => {
      const p = problemes({ ...l, cible: zoneTexte.value });
      alerte.textContent = p.join(" · ");
      zoneTexte.style.borderColor = p.length ? "var(--erreur)" : "";
    };
    zoneTexte.oninput = () => {
      memoriser(l, zoneTexte.value);
      rafraichir();
      enregistrerBientot();
    };
    zoneTexte.onblur = () => dessinerCompteur(lignes());
    rafraichir();
    tdCible.append(zoneTexte, alerte);

    const tdEtat = document.createElement("td");
    tdEtat.className = "etat";
    const badge = (classe, libelle) => {
      const s = document.createElement("span");
      s.className = "badge " + classe;
      s.textContent = libelle;
      tdEtat.append(s, " ");
    };
    if (pageEntiereGelee) badge("gele", t("trad.badge.gele"));
    else if (l.geles.length) badge("gele", t("trad.badge.partiel"));
    for (const v of l.verrous) badge("verrou", v);
    if (!l.geles.length && !l.verrous.length && l.cible) badge("ok", t("trad.badge.ok"));

    tr.append(tdSource, tdCible, tdEtat);
    corps.appendChild(tr);
  }
  table.appendChild(corps);
  zone.appendChild(table);
}

function dessinerCompteur(toutes) {
  // Une page entièrement gelée est recopiée à l'identique : la compter comme
  // traduite gonflerait le score. On la reconnaît à sa structure, pas à son
  // contenu — sinon le total bougerait au fil du remplissage.
  const entierementGelee = (l) =>
    l.geles.length > 0 && l.geles.join("") === l.anglais.replace(/\s/g, "");
  const aFaire = toutes.filter((l) => !entierementGelee(l));
  const traduites = aFaire.filter((l) => l.cible).length;
  const enProbleme = toutes.filter((l) => problemes(l).length).length;
  const geles = toutes.length - aFaire.length;
  $("compteur").textContent =
    t("trad.compteur", { faits: traduites, total: aFaire.length }) +
    (geles ? t("trad.compteur.gelees", { n: geles }) : "") +
    (enProbleme ? t("trad.compteur.problemes", { n: enProbleme }) : "");
}

/** Les trois fichiers de langue, prêts à être déposés dans le dépôt. */
function fichiersDeLangue() {
  // `scripts.json` part indexé par empreinte : le fichier publié ne doit pas
  // contenir le texte anglais du jeu. La clé est celle que l'extraction a
  // résolue — on ne la recalcule pas.
  const parEmpreinte = {};
  for (const [script, paires] of Object.entries(etat.langue.scripts)) {
    for (const [cle, cible] of Object.entries(paires)) {
      if (cible) (parEmpreinte[script] ||= {})[cle] = cible;
    }
  }
  return {
    "documents.json": etat.langue.documents,
    "scenes.json": etat.langue.scenes,
    "scripts.json": { chaines: parEmpreinte },
  };
}

function telecharger(nom, contenu) {
  const blob = new Blob([contenu], { type: "application/json" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = nom;
  a.click();
  URL.revokeObjectURL(a.href);
}

$("telecharger").onclick = async () => {
  for (const [nom, data] of Object.entries(fichiersDeLangue())) {
    telecharger(nom, JSON.stringify(data, null, "\t"));
    await new Promise((r) => setTimeout(r, 150));
  }
  $("journal").hidden = false;
  $("journal").style.color = "var(--attenue)";
  $("journal").textContent =
    `Trois fichiers téléchargés. Ils vont dans locales/${etat.codeLangue}/ du dépôt.`;
};

$("contribuer").onclick = async () => {
  const journal = $("journal");
  journal.hidden = false;
  journal.style.color = "var(--attenue)";

  const problematiques = lignes().filter((l) => problemes(l).length).length;
  if (problematiques) {
    const suite = confirm(
      `${problematiques} ligne(s) portent encore un avertissement dans ce flux.\n\n` +
      "L'intégration continue les rejouera et refusera la fusion si une énigme est " +
      "cassée. Proposer quand même ?"
    );
    if (!suite) return;
  }

  for (const [nom, data] of Object.entries(fichiersDeLangue())) {
    telecharger(nom, JSON.stringify(data, null, "\t"));
    await new Promise((r) => setTimeout(r, 150));
  }

  if (!DEPOT) {
    journal.style.color = "var(--alerte)";
    journal.textContent =
      "Fichiers téléchargés. L'adresse du dépôt n'est pas encore renseignée dans " +
      "cette page — le projet n'est pas publié. Conserve-les, ou envoie-les à qui " +
      "t'a transmis cet éditeur.";
    return;
  }

  // GitHub crée automatiquement une bifurcation pour qui n'a pas les droits
  // d'écriture, et sa page de téléversement ouvre la pull request. Pas de
  // jeton, pas de serveur, et aucune limite de taille — contrairement au
  // pré-remplissage par l'adresse, qui plafonne à quelques kilooctets.
  const url = `https://github.com/${DEPOT}/upload/main/locales/${etat.codeLangue}/`;
  window.open(url, "_blank", "noopener");
  journal.textContent =
    "Fichiers téléchargés, et GitHub ouvert dans un onglet. Dépose-les sur la page, " +
    "décris ta modification, et valide : la pull request part toute seule.";
};


// Les langues du projet, commencées ou non, proposées dès l'ouverture.
//
// Une langue vide a autant sa place qu'une langue finie : c'est le seul moyen
// pour quelqu'un de s'y mettre. On annonce son avancement pour qu'il sache où
// il met les pieds.
const NOMS = {
  fr: "français", de: "allemand", es: "espagnol", it: "italien", nl: "néerlandais",
  "pt-BR": "portugais (BR)", ru: "russe", pl: "polonais", tr: "turc", uk: "ukrainien",
  ja: "japonais", ko: "coréen", "zh-Hans": "chinois simplifié",
};

(async () => {
  const select = $("charger-publiee");
  const langues = await languesPubliees();
  const commencees = langues.filter((l) => l.pages_traduites > 0);
  const vierges = langues.filter((l) => !l.pages_traduites);

  const groupe = (libelle, liste) => {
    if (!liste.length) return;
    const bloc = document.createElement("optgroup");
    bloc.label = libelle;
    for (const l of liste) {
      const option = document.createElement("option");
      option.value = l.langue;
      const nom = NOMS[l.langue] || l.langue;
      option.textContent = l.pages_traduites
        ? t("trad.repartir.pourcent",
            { nom, pourcent: Math.round((100 * l.pages_traduites) / l.pages_totales) })
        : t("trad.repartir.vide", { nom });
      bloc.appendChild(option);
    }
    select.appendChild(bloc);
  };
  groupe(t("trad.repartir.reprendre"), commencees);
  groupe(t("trad.repartir.commencer"), vierges);
})();

// Reprendre le travail en cours, s'il y en a un.
(() => {
  const brouillon = brouillonEnregistre();
  const source = sourceEnregistree();
  if (!brouillon) return;

  const quand = new Date(brouillon.quand).toLocaleString(LANGUE,
    { dateStyle: "short", timeStyle: "short" });
  const nom = NOMS[brouillon.code] || brouillon.code;
  const bandeau = $("reprise");
  bandeau.hidden = false;
  $("reprise-texte").textContent =
    t("reprise.texte", { nom, quand }) + (source ? "." : t("reprise.sansSource"));

  $("reprise-oui").onclick = async () => {
    etat.langue = brouillon.langue;
    etat.codeLangue = brouillon.code;
    $("code-langue").value = brouillon.code;
    if (source) {
      adopter(source);
      $("intro").style.display = "none";
      for (const id of ["charger-langue", "charger-publiee", "flux", "filtre",
                        "telecharger", "contribuer", "code-langue"]) {
        $(id).disabled = false;
      }
      $("journal").hidden = false;
      $("journal").style.color = "var(--attenue)";
      $("journal").textContent =
        `Godot ${source.moteur} · ${source.nombreDeFichiers} fichiers · ` +
        `relu depuis ton navigateur, sans rouvrir le jeu`;
      dessiner();
    }
    bandeau.hidden = true;
    marquerEnregistrement();
  };

  $("reprise-non").onclick = () => {
    if (!confirm(t("reprise.confirmer"))) return;
    oublier();
    bandeau.hidden = true;
  };
})();


// Changer la langue de l'interface redessine ce qui est à l'écran : les entêtes
// de colonnes, les badges et le compteur en font partie.
document.addEventListener("langue-changee", () => {
  if (etat.source.documents) dessiner();
});
