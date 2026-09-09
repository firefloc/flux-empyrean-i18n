#!/usr/bin/env python3
"""Fusionne les deux relevés de chaînes de scènes.

`dump_text.gd` attrape la prose, `dump_ui.gd` les libellés courts branchés sur
une propriété d'affichage. Les premiers extracteurs n'avaient que le premier :
les onglets du journal, « Search… », « Clear », tout le bandeau du HUD étaient
donc invisibles pour la traduction, alors que ce sont les chaînes que le joueur
a sous les yeux en permanence.

Usage: merge_scene_sources.py
"""

from __future__ import annotations

import json
from pathlib import Path

WORK = Path(__file__).resolve().parent.parent / "work"


def main() -> None:
    prose = json.loads((WORK / "strings_scenes.json").read_text(encoding="utf-8"))
    ui = json.loads((WORK / "strings_ui.json").read_text(encoding="utf-8"))
    ajouts = 0
    for scene, entrees in ui.items():
        for index, valeur in entrees.items():
            if index not in prose.setdefault(scene, {}):
                prose[scene][index] = valeur
                ajouts += 1
    (WORK / "strings_scenes.json").write_text(
        json.dumps(prose, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    total = sum(len(v) for v in prose.values())
    print(f"chaînes de scènes : {total} ({ajouts} libellés d'interface ajoutés)")


if __name__ == "__main__":
    main()
