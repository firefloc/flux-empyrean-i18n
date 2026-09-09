// Lecture du pack Godot depuis le navigateur, sans rien téléverser.
//
// Le fichier du jeu fait 827 Mo — on ne le charge jamais entier. `File.slice()`
// donne un accès aléatoire : on lit le pied de page (12 octets), l'en-tête
// (40 octets), puis le répertoire. Ensuite on ne lit que les quelques centaines
// de kilooctets qui portent du texte.
//
// Format du pack, version 4 (Godot 4.7) :
//   pied      : [taille du pack int64][« GDPC »]
//   en-tête   : magie, format, version du moteur, drapeaux,
//               base des fichiers (int64 en 0x18), position du répertoire (0x20)
//   répertoire: [nombre uint32] puis, par fichier,
//               [longueur uint32][chemin][position int64][taille int64][md5 16o][drapeaux uint32]
//
// Le piège : le drapeau 0x2 (« répertoire relatif ») rend les positions des
// fichiers relatives à `début + base`, et non à `début`. Sans ça on lit à côté
// et tout paraît corrompu.

const MAGIE = 0x43504447; // « GDPC » en petit-boutien

async function octets(fichier, position, longueur) {
  return new Uint8Array(await fichier.slice(position, position + longueur).arrayBuffer());
}

function texteUtf8(octets) {
  return new TextDecoder("utf-8", { fatal: true }).decode(octets);
}

async function lireRepertoire(fichier) {
  const taille = fichier.size;
  if (taille < 64) throw new Error("fichier trop petit pour être un jeu Godot");

  const pied = new DataView((await octets(fichier, taille - 12, 12)).buffer);
  let debut;
  if (pied.getUint32(8, true) === MAGIE) {
    // Pack embarqué dans l'exécutable : le pied donne sa taille.
    debut = taille - 12 - Number(pied.getBigInt64(0, true));
  } else {
    debut = 0; // fichier .pck autonome
  }

  const entete = new DataView((await octets(fichier, debut, 40)).buffer);
  if (entete.getUint32(0, true) !== MAGIE) {
    throw new Error("ce fichier ne contient pas de pack Godot (« GDPC » introuvable)");
  }

  const format = entete.getUint32(4, true);
  const moteur = [entete.getUint32(8, true), entete.getUint32(12, true), entete.getUint32(16, true)];
  const drapeaux = format >= 2 ? entete.getUint32(20, true) : 0;
  const base = format >= 2 ? debut + Number(entete.getBigInt64(24, true)) : debut;
  const positionRepertoire = debut + Number(entete.getBigInt64(32, true));

  // Le répertoire fait quelques centaines de kilooctets : on le lit d'un bloc.
  const brut = await octets(fichier, positionRepertoire, Math.min(4 << 20, taille - positionRepertoire));
  const vue = new DataView(brut.buffer);
  const nombre = vue.getUint32(0, true);
  if (nombre === 0 || nombre > 200000) throw new Error("répertoire du pack illisible");

  const fichiers = new Map();
  let i = 4;
  for (let n = 0; n < nombre; n++) {
    const longueur = vue.getUint32(i, true);
    i += 4;
    let chemin = texteUtf8(brut.subarray(i, i + longueur)).replace(/\0+$/, "");
    i += longueur;
    const position = Number(vue.getBigInt64(i, true));
    const tailleFichier = Number(vue.getBigInt64(i + 8, true));
    i += 16 + 16; // positions, taille, empreinte md5
    if (format >= 2) i += 4; // drapeaux du fichier
    fichiers.set(chemin.replace(/^res:\/\//, ""), {
      position: (drapeaux & 0x2 ? base : debut) + position,
      taille: tailleFichier,
    });
  }
  return { format, moteur, fichiers };
}

async function lireEntree(fichier, entree) {
  return octets(fichier, entree.position, entree.taille);
}

// Résout `Scenes/x.tscn` vers le `.scn` réellement exporté. Godot remplace la
// scène par un renvoi ; écrire dans le `.tscn` ne fait rien, silencieusement.
function cibleRemap(contenu) {
  const trouve = texteUtf8(contenu).match(/path="res:\/\/([^"]+)"/);
  return trouve ? trouve[1] : null;
}

// Les chaînes littérales d'un script compilé.
//
// Un `.gdc` est un en-tête « GDSC » de 12 octets suivi d'une trame zstd. Le
// tampon décompressé contient le pool de constantes, une suite de Variants :
// [type uint32][charge]. Pour une String, `type & 0xffff == 4`, puis
// [longueur uint32][utf8 complété à un multiple de 4].
//
// On ne décode pas les jetons du script — leur encodage change d'une version
// de Godot à l'autre, et on n'en a pas besoin. Seul le pool nous intéresse, et
// il se lit sans connaître le reste.
function chainesScript(contenu, decompresser) {
  if (String.fromCharCode(...contenu.subarray(0, 4)) !== "GDSC") return [];
  const vue = new DataView(contenu.buffer, contenu.byteOffset);
  const clair = decompresser(contenu.subarray(12), vue.getUint32(8, true));
  const donnees = new DataView(clair.buffer, clair.byteOffset);
  const sortie = [];
  let i = 0;
  while (i + 8 <= clair.length) {
    if ((donnees.getUint32(i, true) & 0xffff) !== 4) {
      i += 4;
      continue;
    }
    const longueur = donnees.getUint32(i + 4, true);
    if (longueur > 8000 || i + 8 + longueur > clair.length) {
      i += 4;
      continue;
    }
    try {
      sortie.push(texteUtf8(clair.subarray(i + 8, i + 8 + longueur)));
    } catch {
      i += 4;
      continue;
    }
    i += 8 + ((longueur + 3) & ~3);
  }
  return sortie;
}

// Les chaînes d'une scène binaire.
//
// Un `.scn` est une ressource `RSRC`. Ses chaînes s'écrivent [longueur uint32]
// [utf8][octet nul], la longueur comptant le nul. Contrairement au pool d'un
// script, **elles ne sont pas alignées** : un champ de longueur peut commencer
// à n'importe quel décalage. On sonde donc octet par octet.
//
// Le scan est volontairement permissif — il ramène plus de chaînes qu'il n'en
// faut, dont des noms de nœuds et de propriétés. Le tri se fait ensuite par
// empreinte : seule une chaîne annoncée par l'index est retenue.
function chainesScene(contenu) {
  const vue = new DataView(contenu.buffer, contenu.byteOffset, contenu.byteLength);
  const sortie = new Set();
  for (let i = 0; i + 4 < contenu.length; i++) {
    const longueur = vue.getUint32(i, true);
    if (longueur < 2 || longueur > 6000 || i + 4 + longueur > contenu.length) continue;
    if (contenu[i + 4 + longueur - 1] !== 0) continue;
    let valeur;
    try {
      valeur = texteUtf8(contenu.subarray(i + 4, i + 4 + longueur - 1));
    } catch {
      continue;
    }
    if (valeur) sortie.add(valeur);
  }
  return sortie;
}

// Empreinte d'une chaîne source, identique à celle des fichiers de langue :
// les seize premiers caractères du SHA-1, préfixés d'un dièse.
//
// SHA-1 réécrit ici plutôt qu'emprunté à `crypto.subtle` : cette page doit
// s'ouvrir en double-cliquant le fichier, et `file://` ne donne pas partout
// accès à l'API web de chiffrement. Ce n'est pas un usage de sécurité — juste
// un identifiant stable partagé avec l'outillage Python.
function sha1(octets) {
  const h = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0];
  const longueurBits = octets.length * 8;
  const rempli = new Uint8Array((((octets.length + 8) >> 6) + 1) << 6);
  rempli.set(octets);
  rempli[octets.length] = 0x80;
  new DataView(rempli.buffer).setUint32(rempli.length - 4, longueurBits >>> 0, false);
  new DataView(rempli.buffer).setUint32(rempli.length - 8, Math.floor(longueurBits / 4294967296), false);

  const m = new Uint32Array(80);
  const vue = new DataView(rempli.buffer);
  for (let bloc = 0; bloc < rempli.length; bloc += 64) {
    for (let i = 0; i < 16; i++) m[i] = vue.getUint32(bloc + i * 4, false);
    for (let i = 16; i < 80; i++) {
      const x = m[i - 3] ^ m[i - 8] ^ m[i - 14] ^ m[i - 16];
      m[i] = (x << 1) | (x >>> 31);
    }
    let [a, b, c, d, e] = h;
    for (let i = 0; i < 80; i++) {
      let f, k;
      if (i < 20) { f = (b & c) | (~b & d); k = 0x5a827999; }
      else if (i < 40) { f = b ^ c ^ d; k = 0x6ed9eba1; }
      else if (i < 60) { f = (b & c) | (b & d) | (c & d); k = 0x8f1bbcdc; }
      else { f = b ^ c ^ d; k = 0xca62c1d6; }
      const t = (((a << 5) | (a >>> 27)) + f + e + k + m[i]) >>> 0;
      e = d; d = c; c = ((b << 30) | (b >>> 2)) >>> 0; b = a; a = t;
    }
    h[0] = (h[0] + a) >>> 0; h[1] = (h[1] + b) >>> 0; h[2] = (h[2] + c) >>> 0;
    h[3] = (h[3] + d) >>> 0; h[4] = (h[4] + e) >>> 0;
  }
  return h.map((x) => x.toString(16).padStart(8, "0")).join("");
}

function empreinte(texte) {
  return "#" + sha1(new TextEncoder().encode(texte)).slice(0, 16);
}
