#!/usr/bin/env python3
"""Déplie les fichiers d'une langue dans le dossier de travail.

Une langue se décrit en trois fichiers lisibles à la main — `documents.json`,
`scenes.json`, `scripts.json`. Le reste du pipeline attend des formes dérivées :
le corpus veut `{"texts": {...}}`, les scènes veulent seulement ce qui diffère
de l'anglais. Cette conversion est ici, en un seul endroit, pour que les
traducteurs n'aient jamais à connaître ces formes.

Usage: locale_to_work.py   (langue via la variable LOCALE, `fr` par défaut)
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")


def main() -> int:
    # --- documents : {titre: {pages, notes…}} -> {"texts": {titre: pages}}
    documents = json.loads((LOCALE / "documents.json").read_text(encoding="utf-8"))
    textes = {
        titre: charge["pages"]
        for titre, charge in documents.items()
        if isinstance(charge, dict) and charge.get("pages")
    }
    (WORK / "translation_texts.json").write_text(
        json.dumps({"texts": textes}, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )

    # --- scènes : on ne réécrit que ce qui change réellement
    source = json.loads((WORK / "strings_scenes.json").read_text(encoding="utf-8"))
    traduites = json.loads((LOCALE / "scenes.json").read_text(encoding="utf-8"))
    traduites = traduites.get("chaines", traduites)
    diff = {
        scene: {
            index: valeur
            for index, valeur in entrees.items()
            if source.get(scene, {}).get(index) not in (None, valeur)
        }
        for scene, entrees in traduites.items()
    }
    diff = {s: e for s, e in diff.items() if e}
    (WORK / "translation_scenes.json").write_text(
        json.dumps(diff, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )

    # --- scripts : les clés sont des empreintes, on les résout depuis les
    #     chaînes anglaises extraites de la copie du joueur. Le dépôt ne
    #     contient donc pas le texte du jeu.
    brut = json.loads((WORK / "strings_scripts.json").read_text(encoding="utf-8"))
    connues = {
        script: {"#" + hashlib.sha1(v.encode()).hexdigest()[:16]: v
                 for lignes in fichiers.values() for v in lignes}
        for script, fichiers in brut.items()
    }
    scripts = json.loads((LOCALE / "scripts.json").read_text(encoding="utf-8"))
    conteneur = scripts.get("chaines", scripts)
    resolu, introuvables = {}, 0
    for script, paires in conteneur.items():
        index = connues.get(script, {})
        for cle, valeur in paires.items():
            anglais = index.get(cle, cle if not cle.startswith("#") else None)
            if anglais is None:
                introuvables += 1
                continue
            resolu.setdefault(script, {})[anglais] = valeur
    (WORK / "strings_scripts_traduites.json").write_text(
        json.dumps({"chaines": resolu}, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    if introuvables:
        print(f"  {introuvables} empreinte(s) sans correspondance dans cette build — "
              "chaînes ignorées")

    print(
        f"langue {LOCALE.name} : {len(textes)} documents, "
        f"{sum(len(v) for v in diff.values())} chaînes de scènes, "
        f"{sum(1 for p in json.loads((LOCALE / 'scripts.json').read_text(encoding='utf-8')).get('chaines', {}).values() for _ in p)} chaînes de code"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
