// Installer la traduction sans ouvrir un terminal.
//
// Le mod ne contient aucun fichier du jeu : cinq fichiers de texte et de Lua,
// 210 Ko. Les scènes traduites sont fabriquées par le jeu lui-même au premier
// lancement, depuis la copie du joueur. La page n'a donc qu'à écrire ces cinq
// fichiers au bon endroit — pas à construire quoi que ce soit.
//
// Deux voies, selon le navigateur :
//
//   Chrome, Edge   `showDirectoryPicker()` donne un accès en écriture au
//                  dossier du jeu, après confirmation explicite. On y crée
//                  `GDPatch/mods/flux_<langue>/` et on écrit dedans.
//   Firefox        pas d'API d'écriture : on livre un zip, le joueur le
//                  décompresse dans le dossier du jeu. C'est du gestionnaire de
//                  fichiers, pas de la ligne de commande.
//
// Ce que la page ne peut pas faire, et qu'elle dit franchement :
//   - télécharger le chargeur GDPatch. Le CDN de GitHub ne renvoie pas
//     d'en-tête CORS, et de toute façon on ne doit pas le redistribuer. Le
//     joueur le récupère chez ses auteurs et le dépose ici.
//   - régler les options de lancement Steam sous Linux. Elles vivent dans un
//     fichier de configuration que Steam réécrit ; on affiche la ligne à coller.

const ECRITURE_DIRECTE = typeof window.showDirectoryPicker === "function";

const etatInstall = {
  manifeste: null,
  langue: null,
  dossierJeu: null,
  chargeur: null,
};

const $$ = (id) => document.getElementById(id);

function dire(message, ton = "neutre") {
  const zone = $$("install-journal");
  zone.hidden = false;
  zone.textContent = message;
  zone.style.color =
    ton === "erreur" ? "var(--erreur)" : ton === "alerte" ? "var(--alerte)" : "var(--attenue)";
}

async function chargerManifeste() {
  if (etatInstall.manifeste) return etatInstall.manifeste;
  // Sans « no-store », le navigateur sert un manifeste périmé et propose une
  // langue dont les fichiers n'existent plus. Il change à chaque publication.
  const reponse = await fetch("releases/manifeste.json", { cache: "no-store" });
  if (!reponse.ok) throw new Error("aucune traduction publiée sur cette page");
  etatInstall.manifeste = await reponse.json();
  return etatInstall.manifeste;
}

/** Le nom de l'exécutable trahit la plateforme, et donc le chargeur attendu.
 *
 * Sous Proton ou Wine, c'est le jeu Windows qui tourne : le dossier contient un
 * `.exe`, et c'est bien la DLL qu'il faut, pas la bibliothèque Linux. Le
 * système du joueur n'entre pas en ligne de compte — seul compte le binaire
 * que Steam a téléchargé. On le dit explicitement, parce qu'un joueur sous
 * Linux qui voit « Windows » a toutes les raisons de croire à une erreur.
 */
function plateformeDuDossier(noms) {
  if (noms.some((n) => n.endsWith(".exe"))) return "windows";
  if (noms.some((n) => n.endsWith(".x86_64"))) return "linux";
  return null;
}

// Sous Windows — Proton compris — GDPatch se charge en se faisant passer pour
// winmm.dll. Posé sous son nom d'origine il n'est jamais chargé, sans un mot.
const CHARGEURS = {
  linux: "libgdpatch_loader.so",
  windows: "winmm.dll",
};

const LIBELLES = {
  linux: "Linux natif",
  windows: "Windows — y compris sous Proton ou Wine",
};

async function ecrireFichier(dossier, chemin, contenu) {
  const morceaux = chemin.split("/");
  let courant = dossier;
  for (const partie of morceaux.slice(0, -1)) {
    courant = await courant.getDirectoryHandle(partie, { create: true });
  }
  const fichier = await courant.getFileHandle(morceaux.at(-1), { create: true });
  const flux = await fichier.createWritable();
  await flux.write(contenu);
  await flux.close();
}

async function installerDansLeDossier() {
  const manifeste = await chargerManifeste();
  const langue = manifeste.langues.find(
    (l) => l.langue === etatInstall.langue && Array.isArray(l.fichiers)
  );
  if (!langue) throw new Error(`aucun mod construit pour « ${etatInstall.langue} »`);

  const jeu = etatInstall.dossierJeu;
  const noms = [];
  for await (const [nom] of jeu.entries()) noms.push(nom);

  const plateforme = plateformeDuDossier(noms);
  if (!plateforme) {
    throw new Error(
      "ce dossier ne ressemble pas à celui de Flux Empyrean : ni `flux-empyrean.x86_64` " +
      "ni `Flux Empyrean.exe` n'y sont. Choisis le dossier qui contient l'exécutable."
    );
  }

  dire("écriture du mod…");
  const cible = ["GDPatch", "mods", `flux_${etatInstall.langue}`];
  let dossier = jeu;
  for (const partie of cible) dossier = await dossier.getDirectoryHandle(partie, { create: true });

  for (const f of langue.fichiers) {
    const reponse = await fetch(`releases/${etatInstall.langue}/${f.chemin}`);
    if (!reponse.ok) throw new Error(`fichier manquant sur la page : ${f.chemin}`);
    await ecrireFichier(dossier, f.chemin, await reponse.arrayBuffer());
  }

  // Le chargeur, si le joueur l'a déposé. On ne l'héberge pas.
  let chargeurPose = noms.includes(CHARGEURS[plateforme]);
  if (etatInstall.chargeur && !chargeurPose) {
    await ecrireFichier(jeu, CHARGEURS[plateforme], await etatInstall.chargeur.arrayBuffer());
    chargeurPose = true;
  }

  return { plateforme, chargeurPose, fichiers: langue.fichiers.length };
}

/** Sans API d'écriture : un zip, construit à la main pour ne dépendre de rien. */
function zipSansCompression(entrees) {
  const enc = new TextEncoder();
  const local = [];
  const central = [];
  let decalage = 0;

  const crcTable = (() => {
    const t = new Uint32Array(256);
    for (let n = 0; n < 256; n++) {
      let c = n;
      for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
      t[n] = c >>> 0;
    }
    return t;
  })();
  const crc32 = (octets) => {
    let c = 0xffffffff;
    for (const o of octets) c = crcTable[(c ^ o) & 0xff] ^ (c >>> 8);
    return (c ^ 0xffffffff) >>> 0;
  };

  for (const [nom, contenu] of entrees) {
    const nomOctets = enc.encode(nom);
    const donnees = new Uint8Array(contenu);
    const somme = crc32(donnees);

    const entete = new DataView(new ArrayBuffer(30));
    entete.setUint32(0, 0x04034b50, true);
    entete.setUint16(4, 20, true);
    entete.setUint32(14, somme, true);
    entete.setUint32(18, donnees.length, true);
    entete.setUint32(22, donnees.length, true);
    entete.setUint16(26, nomOctets.length, true);
    local.push(new Uint8Array(entete.buffer), nomOctets, donnees);

    const fiche = new DataView(new ArrayBuffer(46));
    fiche.setUint32(0, 0x02014b50, true);
    fiche.setUint16(4, 20, true);
    fiche.setUint16(6, 20, true);
    fiche.setUint32(16, somme, true);
    fiche.setUint32(20, donnees.length, true);
    fiche.setUint32(24, donnees.length, true);
    fiche.setUint16(28, nomOctets.length, true);
    fiche.setUint32(42, decalage, true);
    central.push(new Uint8Array(fiche.buffer), nomOctets);

    decalage += 30 + nomOctets.length + donnees.length;
  }

  const tailleCentral = central.reduce((n, p) => n + p.length, 0);
  const fin = new DataView(new ArrayBuffer(22));
  fin.setUint32(0, 0x06054b50, true);
  fin.setUint16(8, entrees.length, true);
  fin.setUint16(10, entrees.length, true);
  fin.setUint32(12, tailleCentral, true);
  fin.setUint32(16, decalage, true);

  return new Blob([...local, ...central, new Uint8Array(fin.buffer)], {
    type: "application/zip",
  });
}

async function telechargerZip() {
  const manifeste = await chargerManifeste();
  const langue = manifeste.langues.find((l) => l.langue === etatInstall.langue);
  if (!langue?.fichiers) throw new Error(`aucun mod construit pour « ${etatInstall.langue} »`);
  const entrees = [];
  for (const f of langue.fichiers) {
    const reponse = await fetch(`releases/${etatInstall.langue}/${f.chemin}`);
    entrees.push([`GDPatch/mods/flux_${etatInstall.langue}/${f.chemin}`, await reponse.arrayBuffer()]);
  }
  const blob = zipSansCompression(entrees);
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = `flux-empyrean-${etatInstall.langue}.zip`;
  a.click();
  URL.revokeObjectURL(a.href);
}

// --- Câblage -----------------------------------------------------------------

async function preparerInstalleur() {
  const select = $$("install-langue");
  try {
    const manifeste = await chargerManifeste();
    // Le manifeste liste toutes les langues du projet, y compris celles qu'on
    // peut seulement traduire. Ici on n'offre que celles dont le mod est
    // construit : proposer les autres mènerait à une installation vide.
    const installables = manifeste.langues.filter((l) => Array.isArray(l.fichiers));
    select.textContent = "";
    for (const l of installables) {
      const option = document.createElement("option");
      option.value = l.langue;
      option.textContent = `${l.langue} — ${Math.round(l.octets / 1024)} Ko`;
      select.appendChild(option);
    }
    etatInstall.langue = installables[0]?.langue ?? null;
    $$("install-poser").disabled = !etatInstall.langue;
    if (!installables.length) {
      dire(
        "Aucune traduction n'est encore construite pour l'installation. " +
        "L'onglet Traduire, lui, reste ouvert à toutes les langues.",
        "alerte"
      );
    }
  } catch (e) {
    dire(e.message, "alerte");
    $$("install-poser").disabled = true;
  }

  if (!ECRITURE_DIRECTE) {
    $$("install-poser").textContent = t("inst.2.bouton.zip");
    dire(
      "Ton navigateur ne sait pas écrire dans un dossier. Tu auras un zip à " +
      "décompresser dans le dossier du jeu — Chrome et Edge le font à ta place.",
      "alerte"
    );
  }
}

$$("install-langue").onchange = (e) => (etatInstall.langue = e.target.value);
$$("install-chargeur").onchange = (e) => {
  etatInstall.chargeur = e.target.files[0] ?? null;
  if (etatInstall.chargeur) dire(`chargeur retenu : ${etatInstall.chargeur.name}`);
};

$$("install-poser").onclick = async () => {
  try {
    if (!ECRITURE_DIRECTE) {
      await telechargerZip();
      dire(
        "Zip téléchargé. Décompresse-le dans le dossier du jeu : il contient déjà " +
        "l'arborescence GDPatch/mods/, il n'y a rien à réorganiser."
      );
      $$("install-suite").hidden = false;
      return;
    }
    etatInstall.dossierJeu = await window.showDirectoryPicker({ mode: "readwrite" });
    const bilan = await installerDansLeDossier();
    const chargeur = CHARGEURS[bilan.plateforme];
    dire(
      `${bilan.fichiers} fichiers écrits dans GDPatch/mods/flux_${etatInstall.langue}/. ` +
      (bilan.chargeurPose
        ? `Le chargeur ${chargeur} est en place.`
        : `Il manque le chargeur ${chargeur} — récupère-le puis dépose-le ci-dessus.`)
    );
    $$("install-suite").hidden = false;
    $$("install-plateforme").textContent = LIBELLES[bilan.plateforme];
    $$("install-plateforme").dataset.plateforme = bilan.plateforme;
    $$("install-steam").hidden = bilan.plateforme !== "linux";
    $$("install-proton").hidden = bilan.plateforme !== "windows";
  } catch (e) {
    if (e.name === "AbortError") return;
    dire(e.message, "erreur");
  }
};

preparerInstalleur();
