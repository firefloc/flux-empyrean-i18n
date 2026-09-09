#!/usr/bin/env python3
"""Assemble la table Lua des patchs de code : énigmes + déchiffrement.

Les deux patchs ont la même forme — des couples avant/après, plus un bloc
GDScript à ajouter en fin de fichier — et visent des scripts disjoints. On les
fusionne pour que le patcher n'ait qu'une seule table à parcourir.

Usage: gen_answers_lua.py <sortie.lua>
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def lua_str(s: str) -> str:
    out = (
        s.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return f'"{out}"'


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)

    remplacements: dict[str, list] = {}
    aides: dict[str, str] = {}
    for nom in ("answer_patch.json", "decrypt_patch.json"):
        chemin = WORK / nom
        if not chemin.exists():
            print(f"  {nom} absent, ignoré")
            continue
        patch = json.loads(chemin.read_text(encoding="utf-8"))
        for script, paires in patch["remplacements"].items():
            remplacements.setdefault(script, []).extend(paires)
        for script, aide in patch.get("aides", {}).items():
            if script in aides:
                raise SystemExit(f"deux aides pour {script} : à fusionner à la main")
            aides[script] = aide

    lignes = ["-- Généré par tools/gen_answers_lua.py — ne pas éditer à la main.", "return {"]
    lignes.append("\tremplacements = {")
    for script, paires in sorted(remplacements.items()):
        lignes.append(f"\t\t[{lua_str(script)}] = {{")
        # La plus longue d'abord : une chaîne courte contenue dans une longue
        # la mutilerait et la longue ne se retrouverait plus.
        for avant, apres in sorted(paires, key=lambda p: len(p[0]), reverse=True):
            lignes.append(f"\t\t\t{{{lua_str(avant)}, {lua_str(apres)}}},")
        lignes.append("\t\t},")
    lignes.append("\t},")
    lignes.append("\taides = {")
    for script, aide in sorted(aides.items()):
        lignes.append(f"\t\t[{lua_str(script)}] = {lua_str(aide)},")
    lignes.append("\t},")
    lignes.append("}")

    Path(sys.argv[1]).write_text("\n".join(lignes) + "\n", encoding="utf-8")
    total = sum(len(v) for v in remplacements.values())
    print(f"{sys.argv[1]} : {total} remplacements sur {len(remplacements)} scripts, "
          f"{len(aides)} aide(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
