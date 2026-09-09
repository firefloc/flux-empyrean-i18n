#!/usr/bin/env python3
"""Génère l'index que l'éditeur web charge au démarrage.

L'éditeur ne doit embarquer **aucun texte du jeu** : il le lit dans le pack du
joueur. Mais il lui faut la carte — quel document porte combien de pages, quel
nœud de quelle scène porte quelle chaîne, quelles chaînes de code sont
traduisibles. Cette carte se décrit entièrement par des nombres et des
empreintes, donc sans reproduire une ligne de la prose d'origine.

Trois entrées, une sortie par entrée :

- `documents` : la liste des nombres de pages, dans l'ordre du pool de
  constantes de `texts.gdc`. Suffit à regrouper les 768 chaînes à plat en
  167 documents titrés.
- `scripts` et `scenes` : empreinte de la chaîne anglaise, par script et ligne
  ou par scène et nœud. L'éditeur retrouve le texte en empreintant ce qu'il
  extrait du pack.
- `ponts` : quatre chaînes s'écrivent différemment dans la source décompilée et
  dans le pack — `\\n` en deux caractères d'un côté, saut de ligne réel de
  l'autre. Leurs empreintes diffèrent donc. On publie la correspondance entre
  les deux, ce qui ne révèle ni l'une ni l'autre.

Usage: build_index_web.py
"""

from __future__ import annotations

import hashlib
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
JEU = ROOT / "game"
SORTIE = ROOT / "web" / "index"


def empreinte(texte: str) -> str:
    return "#" + hashlib.sha1(texte.encode("utf-8")).hexdigest()[:16]


def desechappe(texte: str) -> str:
    """Forme d'exécution d'une chaîne lue dans la source décompilée.

    Le pack stocke la chaîne telle que le moteur la manipule ; la source
    décompilée l'écrit avec ses échappements. Le sens inverse est ambigu — on
    ne saurait pas lequel des deux guillemets ré-échapper — mais celui-ci ne
    l'est pas, et c'est le seul dont l'éditeur a besoin.
    """
    sortie, i = [], 0
    remplacements = {"n": "\n", "t": "\t", "r": "\r", '"': '"', "'": "'", "\\": "\\"}
    while i < len(texte):
        if texte[i] == "\\" and i + 1 < len(texte) and texte[i + 1] in remplacements:
            sortie.append(remplacements[texte[i + 1]])
            i += 2
        else:
            sortie.append(texte[i])
            i += 1
    return "".join(sortie)


def main() -> None:
    SORTIE.mkdir(parents=True, exist_ok=True)

    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))["texts"]
    pages_par_document = [len(p) for p in corpus.values()]
    # Le regroupement se fait par comptage, donc un document qui gagne une page
    # décalerait tous les suivants — en silence. L'empreinte de chaque titre
    # permet de le constater au lieu de servir des pages mélangées. ChillCash
    # publie une mise à jour par semaine ; ce n'est pas un cas d'école.
    titres = [empreinte(t) for t in corpus]

    scripts = json.loads((WORK / "strings_scripts.json").read_text(encoding="utf-8"))
    index_scripts = {
        fichier: {ligne: [empreinte(s) for s in valeurs] for ligne, valeurs in lignes.items()}
        for fichier, lignes in scripts.items()
    }

    scenes = json.loads((WORK / "strings_scenes.json").read_text(encoding="utf-8"))
    index_scenes = {
        chemin: {noeud: empreinte(s) for noeud, s in noeuds.items()}
        for chemin, noeuds in scenes.items()
    }

    # Les chaînes dont l'écriture source et l'écriture d'exécution divergent.
    ponts = {}
    for lignes in scripts.values():
        for valeurs in lignes.values():
            for source in valeurs:
                execution = desechappe(source)
                if execution != source:
                    ponts[empreinte(execution)] = empreinte(source)

    (SORTIE / "documents.json").write_text(
        json.dumps({"pages_par_document": pages_par_document, "titres": titres}, indent="\t"),
        encoding="utf-8",
    )
    (SORTIE / "scripts.json").write_text(
        json.dumps(index_scripts, indent="\t"), encoding="utf-8"
    )
    (SORTIE / "scenes.json").write_text(json.dumps(index_scenes, indent="\t"), encoding="utf-8")
    (SORTIE / "ponts.json").write_text(json.dumps(ponts, indent="\t"), encoding="utf-8")

    # Les verrous d'énigme et le relevé manuel de gel décrivent la logique du
    # jeu, pas sa prose. Sans eux l'éditeur ne peut pas prévenir le traducteur
    # qu'il vient de rendre une énigme insoluble — c'est tout l'intérêt.
    shutil.copyfile(WORK / "puzzle_locks.json", SORTIE / "verrous.json")
    shutil.copyfile(JEU / "frozen_manual.json", SORTIE / "gel_manuel.json")

    total_scripts = sum(len(v) for l in index_scripts.values() for v in l.values())
    total_scenes = sum(len(v) for v in index_scenes.values())
    print(
        f"documents : {len(pages_par_document)} ({sum(pages_par_document)} pages) | "
        f"scripts : {total_scripts} chaînes dans {len(index_scripts)} fichiers | "
        f"scènes : {total_scenes} chaînes dans {len(index_scenes)} scènes | "
        f"ponts : {len(ponts)}"
    )
    fuite = [p for p in SORTIE.glob("*.json") if p.name in {"documents.json", "scripts.json", "scenes.json", "ponts.json"}]
    for p in fuite:
        contenu = p.read_text(encoding="utf-8")
        for pages in corpus.values():
            for page in pages:
                extrait = page.strip()[:40]
                if len(extrait) >= 20 and extrait in contenu:
                    raise SystemExit(f"{p.name} contient du texte du jeu : {extrait!r}")
    print("contrôle : aucun texte du jeu dans l'index")


if __name__ == "__main__":
    main()
