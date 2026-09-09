// Reconstitue les trois colonnes source depuis le pack du joueur.
//
// Rien de ce texte n'est publié avec l'éditeur : le dépôt ne contient que
// `index/`, c'est-à-dire des nombres de pages et des empreintes. Le texte
// anglais vient de la copie du joueur, et n'en sort jamais.

const INDEX = ["documents", "scripts", "scenes", "ponts", "verrous", "gel_manuel"];

async function chargerIndex() {
  const entrees = await Promise.all(
    INDEX.map(async (nom) => {
      const reponse = await fetch(`index/${nom}.json`);
      if (!reponse.ok) throw new Error(`index/${nom}.json introuvable`);
      return [nom, await reponse.json()];
    })
  );
  return Object.fromEntries(entrees);
}

function decompresser(donnees, tailleAttendue) {
  const clair = fzstd.decompress(donnees, new Uint8Array(tailleAttendue));
  return clair.length === tailleAttendue ? clair : clair.subarray(0, tailleAttendue);
}

// Les 167 documents, regroupés depuis le pool à plat de `texts.gdc`.
//
// Le pool livre 812 chaînes dans l'ordre où le script les déclare : un titre,
// ses pages, le titre suivant. `pages_par_document` suffit donc à retrouver la
// structure — 167 entiers, pas un mot de la prose.
// Le regroupement se fait par comptage : un document qui gagne une page
// décalerait tous les suivants, et l'éditeur servirait des pages mélangées sans
// rien dire. L'empreinte de chaque titre attendu permet de le constater —
// ChillCash publie une mise à jour par semaine, l'index se périme vite.
function grouperDocuments(pool, index) {
  const documents = [];
  let i = 0;
  index.pages_par_document.forEach((nombreDePages, rang) => {
    if (i + 1 + nombreDePages > pool.length) return;
    const titre = pool[i];
    const attendu = index.titres?.[rang];
    if (attendu && empreinte(titre) !== attendu) {
      throw new Error(
        "l'index ne correspond plus à cette version du jeu : le corpus a bougé " +
        `au document n° ${rang + 1}. Régénère web/index/ avec tools/build_index_web.py.`
      );
    }
    documents.push({ titre, pages: pool.slice(i + 1, i + 1 + nombreDePages) });
    i += 1 + nombreDePages;
  });
  return documents;
}

// --- Segments à ne jamais traduire ------------------------------------------
//
// Port du `build_frozen.py` de l'outillage : mêmes seuils, mêmes règles. Le
// joueur saisit une clé et le jeu applique un Vigenère à la page après avoir
// retiré tout ce qui n'est pas une lettre. Une lettre en plus décale tout le
// message. Même verdict pour la langue xérétique et les jeux d'écriture.
//
// Le doute profite au gel : un segment gelé à tort laisse une ligne en
// anglais, un segment traduit à tort casse une énigme sans message d'erreur.

function vocabulaire(documents) {
  const compte = new Map();
  for (const doc of documents) {
    for (const page of doc.pages) {
      for (const mot of page.match(/[A-Za-z']+/g) || []) {
        const cle = mot.toLowerCase();
        compte.set(cle, (compte.get(cle) || 0) + 1);
      }
    }
  }
  return compte;
}

function classer(ligne, vocab) {
  const lettres = ligne.match(/[A-Za-z]/g) || [];
  const mots = (ligne.match(/[A-Za-z']+/g) || []).map((m) => m.toLowerCase());
  if (lettres.length < 12 || mots.length === 0) return null;

  const capitales = lettres.filter((c) => c >= "A" && c <= "Z").length / lettres.length;
  const motLePlusLong = Math.max(...mots.map((m) => m.length));
  // Un bloc Vigenère est souvent un seul « mot » de cent lettres : le compte de
  // mots ne veut rien dire, seule la masse de capitales compte.
  if (capitales > 0.7 && lettres.length >= 20 && motLePlusLong >= 15) return "chiffre_vigenere";
  if (mots.length < 3) return null;

  // Part des mots qui vivent ailleurs dans le corpus. Un mot d'une ligne
  // chiffrée n'y apparaît que par lui-même, d'où le seuil à 3.
  const connus = mots.filter((m) => (vocab.get(m) || 0) >= 3).length / mots.length;
  if (connus >= 0.35) return null;

  if (capitales > 0.7 && lettres.length >= 30) return "chiffre_vigenere";
  if (/[A-Za-z][0-9]|[0-9][A-Za-z]/.test(ligne)) return "jeu_d_ecriture";
  return "langue_construite";
}

// Une page se désigne par son titre et son rang. Le séparateur est un octet
// nul : il ne peut pas apparaître dans un titre, là où un espace le pourrait.
function clePage(titre, page) {
  return `${titre}\u0000${page}`;
}

function releverGel(documents, gelManuel) {
  const vocab = vocabulaire(documents);
  const gel = new Map(); // clePage(titre, page) -> [{type, segment}]
  const ajouter = (titre, page, type, segment) => {
    const cle = clePage(titre, page);
    if (!gel.has(cle)) gel.set(cle, []);
    if (!gel.get(cle).some((s) => s.segment === segment)) gel.get(cle).push({ type, segment });
  };

  for (const doc of documents) {
    doc.pages.forEach((page, index) => {
      for (const ligne of page.split("\n")) {
        const nettoye = ligne.trim();
        const type = classer(nettoye, vocab);
        if (type) ajouter(doc.titre, index, type, nettoye);
      }
    });
  }
  // Les cas que l'heuristique laisse passer, relevés à la main après lecture.
  for (const [titre, pages] of Object.entries(gelManuel)) {
    const doc = documents.find((d) => d.titre === titre);
    if (!doc) continue;
    for (const [index, type] of Object.entries(pages)) {
      const page = doc.pages[Number(index)];
      if (page === undefined) continue;
      for (const ligne of page.split("\n")) {
        const nettoye = ligne.trim();
        if (nettoye) ajouter(titre, Number(index), type, nettoye);
      }
    }
  }
  return gel;
}

// --- Extraction complète -----------------------------------------------------

async function extraire(fichier, progression) {
  const index = await chargerIndex();
  progression("lecture du répertoire du pack…");
  const pack = await lireRepertoire(fichier);

  const lire = async (chemin) => {
    const entree = pack.fichiers.get(chemin);
    return entree ? lireEntree(fichier, entree) : null;
  };

  // 1. Les documents.
  progression("documents…");
  const brutTextes = await lire("Scripts/texts.gdc");
  if (!brutTextes) throw new Error("`Scripts/texts.gdc` absent : ce pack n'est pas Flux Empyrean");
  const documents = grouperDocuments(
    chainesScript(brutTextes, decompresser),
    index.documents
  );
  const gel = releverGel(documents, index.gel_manuel);

  // 2. Les chaînes de code. On empreinte ce qu'on trouve dans le pool, et on
  //    ne retient que ce que l'index annonce. Quatre chaînes s'écrivent
  //    autrement dans la source décompilée que dans le pack — `ponts` fait la
  //    correspondance entre les deux empreintes.
  progression("chaînes de code…");
  const scripts = {};
  let scriptsManquants = 0;
  for (const [chemin, lignes] of Object.entries(index.scripts)) {
    const brut = await lire(chemin);
    if (!brut) {
      scriptsManquants++;
      continue;
    }
    const parEmpreinte = new Map();
    for (const chaine of chainesScript(brut, decompresser)) {
      const cle = empreinte(chaine);
      parEmpreinte.set(index.ponts[cle] || cle, chaine);
    }
    const trouvees = {};
    for (const [ligne, empreintes] of Object.entries(lignes)) {
      for (const cle of empreintes) {
        const texte = parEmpreinte.get(cle);
        if (texte !== undefined) trouvees[cle] = { texte, ligne };
      }
    }
    if (Object.keys(trouvees).length) scripts[chemin] = trouvees;
  }

  // 3. Les scènes. Godot remplace chaque `.tscn` par un renvoi vers le `.scn`
  //    réellement exporté ; il faut suivre le renvoi.
  progression("scènes…");
  const scenes = {};
  let scenesManquantes = 0;
  for (const [chemin, noeuds] of Object.entries(index.scenes)) {
    const relatif = chemin.replace(/^res:\/\//, "");
    const renvoi = await lire(`${relatif}.remap`);
    const brut = renvoi ? await lire(cibleRemap(renvoi)) : await lire(relatif);
    if (!brut) {
      scenesManquantes++;
      continue;
    }
    const parEmpreinte = new Map();
    for (const chaine of chainesScene(brut)) parEmpreinte.set(empreinte(chaine), chaine);
    const trouvees = {};
    for (const [noeud, cle] of Object.entries(noeuds)) {
      const texte = parEmpreinte.get(cle);
      if (texte !== undefined) trouvees[noeud] = { texte, empreinte: cle };
    }
    if (Object.keys(trouvees).length) scenes[chemin] = trouvees;
  }

  return {
    moteur: pack.moteur.join("."),
    nombreDeFichiers: pack.fichiers.size,
    documents,
    gel,
    scripts,
    scenes,
    verrous: index.verrous,
    manques: { scripts: scriptsManquants, scenes: scenesManquantes },
  };
}
