#!/usr/bin/env python3
"""Ré-indexe la traduction des scènes sur la build courante.

Une scène traduite est décrite par des index dans son tableau `variants`. Ces
index ne sont pas stables : la mise à jour du 8 septembre en a décalé un d'une
position dans `drum_of_war.tscn`. Traduire à l'aveugle sur l'ancien index aurait
réécrit la mauvaise chaîne, sans qu'aucun contrôle ne bronche.

On réapparie donc par **contenu anglais** : pour chaque traduction, on retrouve
l'index qui porte aujourd'hui la chaîne d'origine. Ce qui ne se retrouve pas est
signalé plutôt que deviné.

Usage: remap_scenes.py <strings_scenes.json de la build courante>
Réécrit work/translation_scenes.json.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    courant = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    origine = json.loads((WORK / "strings_scenes.json").read_text(encoding="utf-8"))
    traduction = json.loads((WORK / "translation_scenes.json").read_text(encoding="utf-8"))

    nouveau: dict[str, dict[str, str]] = {}
    inchanges = deplaces = perdus = 0
    for scene, entrees in traduction.items():
        for index, fr in entrees.items():
            anglais = origine.get(scene, {}).get(index)
            if anglais is None:
                print(f"  [PERDU] {scene} [{index}] : absent de la build d'origine")
                perdus += 1
                continue
            cible = courant.get(scene, {})
            if cible.get(index) == anglais:
                nouveau.setdefault(scene, {})[index] = fr
                inchanges += 1
                continue
            candidats = [k for k, v in cible.items() if v == anglais]
            if len(candidats) == 1:
                nouveau.setdefault(scene, {})[candidats[0]] = fr
                print(f"  [DÉPLACÉ] {scene.split('/')[-1]} [{index}] -> [{candidats[0]}]")
                deplaces += 1
            else:
                print(
                    f"  [PERDU] {scene.split('/')[-1]} [{index}] : "
                    f"{len(candidats)} correspondance(s) pour « {anglais[:40]} »"
                )
                perdus += 1

    (WORK / "translation_scenes.json").write_text(
        json.dumps(nouveau, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(f"\ninchangés : {inchanges} | déplacés : {deplaces} | perdus : {perdus}")
    return 1 if perdus else 0


if __name__ == "__main__":
    sys.exit(main())
