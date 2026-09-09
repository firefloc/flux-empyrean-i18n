#!/usr/bin/env python3
"""Garde-fou avant d'écrire des scènes traduites.

Toutes les chaînes d'une scène ne sont pas du texte affiché. `Disc.text` est un
`@export` qui sert d'**index** dans `Texts.texts[…]` : le traduire ne casse pas
une énigme, **ça plante le jeu**. Et `name_answer` / `title_answer` / `answer`
sont des réponses d'énigme, qui doivent rester dans leur graphie d'origine.

Le relevé initial ne distinguait pas ces cas — un nœud `Disc` et un nœud
`Label` exposent tous deux une propriété qui s'appelle `text`. `map_props.gd`
croise l'état de scène avec le tableau `variants` pour rattacher chaque index à
la propriété qui l'utilise ; ce script exploite cette carte.

Usage: verify_scenes.py
Sortie 0 si aucune chaîne dangereuse n'a été modifiée, 1 sinon.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"

# Propriétés dont la valeur est lue par le code, jamais affichée telle quelle.
INTOUCHABLES = {
    "text_key",
    "answer",
    "answers",
    "name_answer",
    "title_answer",
    "code",
    "solution",
    "password",
    "direction",
}

# `text` est ambigu : affiché sur un Label, mais clé de dictionnaire sur un Disc.
NOEUDS_CLES = ("disc.tscn", "wimlock.tscn")


def dangereuse(usages: list[dict]) -> str | None:
    for u in usages:
        prop = u.get("prop", "")
        if prop in INTOUCHABLES:
            return prop
        if prop == "text" and any(n in u.get("type", "") for n in NOEUDS_CLES):
            return f"{prop} (clé de dictionnaire sur {u.get('type', '?')})"
    return None


def main() -> int:
    src = json.loads((WORK / "strings_scenes_a_traduire.json").read_text(encoding="utf-8"))["chaines"]
    fr = json.loads((WORK / "strings_scenes_traduites.json").read_text(encoding="utf-8"))
    fr = fr.get("chaines", fr)
    carte = json.loads((WORK / "scene_prop_map.json").read_text(encoding="utf-8"))

    erreurs, modifiees, sans_carte = [], 0, 0
    for scene, entrees in fr.items():
        for index, valeur in entrees.items():
            origine = src.get(scene, {}).get(index)
            if origine is None or valeur == origine:
                continue
            modifiees += 1
            usages = carte.get(scene, {}).get(index)
            if usages is None:
                sans_carte += 1
                continue
            motif = dangereuse(usages if isinstance(usages, list) else [usages])
            if motif:
                erreurs.append(
                    f"{scene} [{index}] : « {origine[:40]} » modifiée alors qu'elle "
                    f"sert la propriété {motif}"
                )

    print(f"chaînes traduites : {modifiees} | non rattachées à une propriété : {sans_carte}")
    for e in erreurs:
        print(f"  [ERREUR] {e}")
    print(f"\n{len(erreurs)} chaîne(s) dangereuse(s) modifiée(s)")
    return 1 if erreurs else 0


if __name__ == "__main__":
    sys.exit(main())
