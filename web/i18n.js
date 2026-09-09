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

const TEXTES = {
  en: {
    "page.titre": "Flux Empyrean — translation (experimental)",
    "entete.titre": "Empyrean — translation",
    "entete.etiquette": "experimental",
    "entete.accroche":
      "Community tool, still being shaped. Your game never leaves your browser. " +
      "The French translation was produced by an AI, before anyone had finished " +
      "the game — expect rough edges, and report them.",
    "onglet.installer": "Install the translation",
    "onglet.traduire": "Translate",

    "inst.titre": "Play in your language, without opening a terminal",
    "inst.chapo.1": "The mod contains ",
    "inst.chapo.fort": "no game file",
    "inst.chapo.2":
      " — 210 KB of text and Lua. It changes nothing: it sits alongside, and " +
      "uninstalls by deleting two things. Everything happens in your browser, " +
      "nothing is uploaded.",
    "inst.1.titre": "The loader",
    "inst.1.corps.1": " injects the mod when the game starts. It is not ours, and we do not redistribute it.",
    "inst.1.detail":
      "{so} if Steam gave you the Linux build, {dll} if it gave you the Windows " +
      "build — including under Proton or Wine. The game binary decides, not your " +
      "system. The page will tell you which one it found.",
    "inst.1.depose": "Drop it here",
    "inst.2.titre": "The translation",
    "inst.2.corps": "Pick your language, then point at the game folder.",
    "inst.2.detail":
      "The one containing {linux} or {windows}. The page only writes {gdpatch} and " +
      "the loader — it touches no existing file, and reads nothing else.",
    "inst.2.bouton": "Put it in my game…",
    "inst.2.bouton.zip": "Download the mod (.zip)",
    "inst.3.titre": "Launch twice",
    "inst.3.corps":
      "The first launch builds the translated screens from your own copy — a few " +
      "seconds, once. The second one shows them.",
    "inst.3.detail":
      "That is how the mod carries no game file: the 47 scenes are born on your " +
      "machine. They rebuild themselves when the game updates, so you never think " +
      "about it again. Detected platform: ",
    "inst.4.titre": "One line in Steam",
    "inst.4.linux": "Native Linux game: right-click the game → Properties → Launch options.",
    "inst.4.linux.detail":
      "This script comes from gdpatch.dev and sits next to the loader. It is needed " +
      "because the Steam install path contains a space, which LD_PRELOAD splits on.",
    "inst.4.proton": "Under Proton or Wine: right-click the game → Properties → Launch options.",
    "inst.4.proton.detail":
      "Without it, Wine never loads the mod — and says nothing. On real Windows " +
      "there is nothing to do.",
    "inst.4.proton.avertissement":
      "Worth knowing: under Proton, the game itself has an input problem — clicks " +
      "do not register in menus. Verified without the mod: it is not the " +
      "translation. Try holding right-click while left-clicking, disable Steam " +
      "Input, or switch Proton build. The native Linux game does not have this.",
    "inst.repli.titre": "What exactly gets written, and how to remove it all",
    "inst.repli.1": "The mod adds two things to the game folder, and nothing else:",
    "inst.repli.2":
      "On first launch the game also writes {data} — the 47 scenes it just built, " +
      "about 6 MB, made from your copy and never travelling anywhere.",
    "inst.repli.3":
      "To go back to the original game: delete those two entries and remove the " +
      "line from the Steam launch options. No game file has been modified, and a " +
      "Steam integrity check will not remove them either — they are files Steam " +
      "does not know about.",
    "inst.repli.4":
      "One Steam achievement unlocks on first launch, mod or no mod: " +
      "text_manager.gd marks the tutorial journal entry as read at startup, which " +
      "counts as a passage found. That is the game, not the mod.",

    "trad.ouvrir": "Open my game…",
    "trad.repartir": "Start from a translation…",
    "trad.repartir.reprendre": "Continue a translation",
    "trad.repartir.commencer": "Start a new one",
    "trad.repartir.pourcent": "{nom} — {pourcent} %",
    "trad.repartir.vide": "{nom} — to be started",
    "trad.fichiers": "My files…",
    "trad.fichiers.titre": "Load your own language files",
    "trad.flux.documents": "Documents",
    "trad.flux.scenes": "Scenes and interface",
    "trad.flux.scripts": "Code strings",
    "trad.filtre": "filter…",
    "trad.restants": "untranslated only",
    "trad.langue": "language",
    "trad.telecharger": "Download",
    "trad.contribuer": "Propose to the project",
    "trad.colonne.original": "Original",
    "trad.colonne.traduction": "Translation",
    "trad.colonne.etat": "State",
    "trad.vide": "Nothing to show with this filter.",
    "trad.compteur": "{faits} / {total} translated",
    "trad.compteur.gelees": " · {n} frozen",
    "trad.compteur.problemes": " · {n} to fix",
    "trad.badge.gele": "frozen",
    "trad.badge.partiel": "partial",
    "trad.badge.ok": "ok",

    "reprise.texte": "You have a draft in {nom}, saved on {quand}",
    "reprise.sansSource": " — you will need to reopen your game to edit it.",
    "reprise.oui": "Continue",
    "reprise.non": "Delete",
    "reprise.confirmer": "Delete this draft for good?",
    "brouillon.enregistre": "draft saved at {heure}",
    "brouillon.plein": "draft not saved: browser storage is full",

    "intro.titre": "How it works",
    "intro.1":
      "This editor contains no game text — deliberately, the prose belongs to its " +
      "author. It reads the pack of your own copy, here, in your browser. Nothing " +
      "is uploaded, there is no server and no account.",
    "intro.2":
      "Open the game file: flux-empyrean.x86_64 on Linux, Flux Empyrean.exe on " +
      "Windows, or the .pck if it sits separately. The page reads the pack " +
      "directory and pulls out only the few hundred kilobytes that carry text — " +
      "the file is 827 MB and is never loaded whole.",
    "intro.3":
      "Edit the right-hand column, then Propose to the project: your three files " +
      "download and GitHub opens on the upload page, which creates the pull " +
      "request for you.",
    "intro.gel":
      "Rows in amber are frozen: cipher blocks, constructed language, rebuses. The " +
      "game strips everything that is not a letter before decrypting — one extra " +
      "letter shifts the whole message. The editor makes them read-only.",
  },

  fr: {
    "page.titre": "Flux Empyrean — traduction (expérimental)",
    "entete.titre": "Empyrean — traduction",
    "entete.etiquette": "expérimental",
    "entete.accroche":
      "Outil communautaire, en cours de mise au point. Ton jeu ne quitte pas ton " +
      "navigateur. La traduction française a été produite par une IA, avant que " +
      "quiconque ait terminé le jeu — attends-toi à des maladresses, et signale-les.",
    "onglet.installer": "Installer la traduction",
    "onglet.traduire": "Traduire",

    "inst.titre": "Jouer dans ta langue, sans ouvrir un terminal",
    "inst.chapo.1": "Le mod ne contient ",
    "inst.chapo.fort": "aucun fichier du jeu",
    "inst.chapo.2":
      " — 210 Ko de texte et de Lua. Il ne modifie rien : il s'ajoute à côté, et se " +
      "retire en supprimant deux choses. Tout se passe dans ton navigateur, rien " +
      "n'est téléversé.",
    "inst.1.titre": "Le chargeur",
    "inst.1.corps.1": " injecte le mod au démarrage du jeu. Il ne nous appartient pas, on ne le redistribue pas.",
    "inst.1.detail":
      "{so} si Steam t'a livré le jeu Linux, {dll} s'il t'a livré le jeu Windows — " +
      "y compris sous Proton ou Wine. C'est le binaire du jeu qui décide, pas ton " +
      "système. La page te dira lequel elle a trouvé.",
    "inst.1.depose": "Dépose-le ici",
    "inst.2.titre": "La traduction",
    "inst.2.corps": "Choisis ta langue, puis désigne le dossier du jeu.",
    "inst.2.detail":
      "Celui qui contient {linux} ou {windows}. La page n'y écrit que {gdpatch} et " +
      "le chargeur — elle ne touche à aucun fichier existant, et ne lit rien d'autre.",
    "inst.2.bouton": "Poser dans mon jeu…",
    "inst.2.bouton.zip": "Télécharger le mod (.zip)",
    "inst.3.titre": "Lancer deux fois",
    "inst.3.corps":
      "Le premier lancement fabrique les écrans traduits depuis ta propre copie — " +
      "quelques secondes, une seule fois. Le second les affiche.",
    "inst.3.detail":
      "C'est ce qui permet au mod de ne transporter aucun fichier du jeu : les " +
      "47 scènes naissent chez toi. Elles se refont toutes seules quand le jeu se " +
      "met à jour, donc tu n'y repenseras plus. Plateforme détectée : ",
    "inst.4.titre": "Une ligne dans Steam",
    "inst.4.linux": "Jeu Linux natif : clic droit sur le jeu → Propriétés → Options de lancement.",
    "inst.4.linux.detail":
      "Ce script se récupère sur gdpatch.dev et se pose à côté du chargeur. Il est " +
      "nécessaire parce que le chemin d'installation Steam contient une espace, sur " +
      "laquelle LD_PRELOAD découpe.",
    "inst.4.proton": "Sous Proton ou Wine : clic droit sur le jeu → Propriétés → Options de lancement.",
    "inst.4.proton.detail":
      "Sans elle, Wine ne charge jamais le mod — et ne dit rien. Sous Windows " +
      "véritable, il n'y a rien à faire.",
    "inst.4.proton.avertissement":
      "À savoir : sous Proton, le jeu lui-même a un défaut d'entrée — les clics ne " +
      "répondent pas dans les menus. Vérifié sans le mod : ce n'est pas la " +
      "traduction. Essaie de maintenir le clic droit pendant le clic gauche, " +
      "désactive Steam Input, ou change de version de Proton. Le jeu Linux natif " +
      "n'a pas ce problème.",
    "inst.repli.titre": "Ce que ça écrit exactement, et comment tout retirer",
    "inst.repli.1": "Le mod ajoute deux choses au dossier du jeu, et rien d'autre :",
    "inst.repli.2":
      "Au premier lancement, le jeu écrit en plus {data} — les 47 scènes qu'il " +
      "vient de fabriquer, environ 6 Mo, produites à partir de ta copie et qui ne " +
      "voyagent jamais.",
    "inst.repli.3":
      "Pour revenir au jeu d'origine : supprime ces deux entrées et retire la ligne " +
      "des options de lancement Steam. Aucun fichier du jeu n'a été modifié, et une " +
      "vérification d'intégrité Steam ne les enlève pas non plus — ce sont des " +
      "fichiers que Steam ne connaît pas.",
    "inst.repli.4":
      "Un succès Steam se débloque au premier lancement, mod ou pas : " +
      "text_manager.gd marque l'entrée tutoriel du journal comme lue au démarrage, " +
      "ce qui compte comme un passage trouvé. C'est le jeu, pas le mod.",

    "trad.ouvrir": "Ouvrir mon jeu…",
    "trad.repartir": "Repartir d'une traduction…",
    "trad.repartir.reprendre": "Reprendre une traduction",
    "trad.repartir.commencer": "En commencer une",
    "trad.repartir.pourcent": "{nom} — {pourcent} %",
    "trad.repartir.vide": "{nom} — à commencer",
    "trad.fichiers": "Mes fichiers…",
    "trad.fichiers.titre": "Charger tes propres fichiers de langue",
    "trad.flux.documents": "Documents",
    "trad.flux.scenes": "Scènes et interface",
    "trad.flux.scripts": "Chaînes de code",
    "trad.filtre": "filtrer…",
    "trad.restants": "à traduire seulement",
    "trad.langue": "langue",
    "trad.telecharger": "Télécharger",
    "trad.contribuer": "Proposer au projet",
    "trad.colonne.original": "Original",
    "trad.colonne.traduction": "Traduction",
    "trad.colonne.etat": "État",
    "trad.vide": "Rien à afficher avec ce filtre.",
    "trad.compteur": "{faits} / {total} traduites",
    "trad.compteur.gelees": " · {n} gelées",
    "trad.compteur.problemes": " · {n} à corriger",
    "trad.badge.gele": "gelé",
    "trad.badge.partiel": "partiel",
    "trad.badge.ok": "ok",

    "reprise.texte": "Tu as un brouillon en {nom}, enregistré le {quand}",
    "reprise.sansSource": " — il te faudra rouvrir ton jeu pour l'éditer.",
    "reprise.oui": "Reprendre",
    "reprise.non": "Supprimer",
    "reprise.confirmer": "Supprimer définitivement ce brouillon ?",
    "brouillon.enregistre": "brouillon enregistré à {heure}",
    "brouillon.plein": "brouillon non enregistré : espace du navigateur plein",

    "intro.titre": "Comment ça marche",
    "intro.1":
      "Cet éditeur ne contient aucun texte du jeu — c'est volontaire, la prose " +
      "appartient à son auteur. Il lit le pack de ta propre copie, ici, dans ton " +
      "navigateur. Rien n'est téléversé, il n'y a ni serveur ni compte.",
    "intro.2":
      "Ouvre le fichier du jeu : flux-empyrean.x86_64 sous Linux, " +
      "Flux Empyrean.exe sous Windows, ou le .pck s'il est séparé. La page en lit " +
      "le sommaire et n'extrait que les quelques centaines de kilooctets qui " +
      "portent du texte — le fichier fait 827 Mo, il n'est jamais chargé en entier.",
    "intro.3":
      "Édite la colonne de droite, puis Proposer au projet : tes trois fichiers se " +
      "téléchargent et GitHub s'ouvre sur la page de dépôt, qui crée la pull " +
      "request pour toi.",
    "intro.gel":
      "Les lignes en orange sont gelées : blocs chiffrés, langue construite, " +
      "rébus. Le jeu retire tout ce qui n'est pas une lettre avant de déchiffrer — " +
      "une lettre en plus décale tout le message. L'éditeur les met en lecture seule.",
  },
};

const LANGUES_UI = { en: "English", fr: "Français" };
const CLE_LANGUE_UI = "flux-empyrean:langue-ui";

function langueChoisie() {
  const retenue = localStorage.getItem(CLE_LANGUE_UI);
  if (retenue && TEXTES[retenue]) return retenue;
  // `navigator.languages` est classé par préférence : on prend la première
  // qu'on sait parler, sur sa base — « fr-CA » doit donner « fr ».
  for (const demandee of navigator.languages || [navigator.language || "en"]) {
    const base = String(demandee).split("-")[0];
    if (TEXTES[base]) return base;
  }
  return "en";
}

let LANGUE = langueChoisie();

/** Un texte de l'interface, avec ses trous remplis. L'anglais sert de filet. */
function t(cle, valeurs = {}) {
  const brut = TEXTES[LANGUE]?.[cle] ?? TEXTES.en[cle] ?? cle;
  return brut.replace(/\{(\w+)\}/g, (entier, nom) =>
    nom in valeurs ? String(valeurs[nom]) : entier
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
  document.dispatchEvent(new CustomEvent("langue-changee"));
}

function changerLangue(code) {
  if (!TEXTES[code]) return;
  LANGUE = code;
  localStorage.setItem(CLE_LANGUE_UI, code);
  appliquerLangue();
}
