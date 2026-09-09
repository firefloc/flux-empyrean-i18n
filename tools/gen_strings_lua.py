#!/usr/bin/env python3
"""Génère la table de remplacement des chaînes noyées dans le code.

Le remplacement se fait par substitution de texte sur la source décompilée, et
**l'ordre compte** : `"%s added to journal."` est une sous-chaîne de
`"%s %s added to journal."`. Remplacer la courte en premier détruit la longue,
qui reste alors en anglais sans que rien ne le signale. Les paires sont donc
triées par longueur décroissante.

Usage: gen_strings_lua.py <sortie.lua>
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
    fr = json.loads((WORK / "strings_scripts_traduites.json").read_text(encoding="utf-8"))
    fr = fr.get("chaines", fr)

    # Une traduction qui contient un guillemet droit ou un antislash isolé casse
    # le littéral GDScript une fois réinjectée, et le script entier cesse de
    # compiler — silencieusement, puisque GDPatch garde alors l'original.
    fautives = [
        (script, en, f)
        for script, paires in fr.items()
        for en, f in paires.items()
        if f and f != en and ('"' in f or "\n" in f)
    ]
    if fautives:
        for script, en, f in fautives:
            print(f"  [REFUS] {script} :: {f[:70]!r} contient un guillemet ou un saut de ligne brut")
        raise SystemExit(
            f"{len(fautives)} traduction(s) casseraient le littéral GDScript. "
            "Emploie « » plutôt que des guillemets droits."
        )

    lignes = ["-- Généré par tools/gen_strings_lua.py — ne pas éditer à la main.", "return {"]
    total, scripts = 0, 0
    for script, paires in sorted(fr.items()):
        utiles = [(en, f) for en, f in paires.items() if f and f != en]
        if not utiles:
            continue
        # La plus longue d'abord : sinon une chaîne courte contenue dans une
        # longue la mutile, et la longue ne se retrouve plus.
        utiles.sort(key=lambda p: len(p[0]), reverse=True)
        lignes.append(f"\t[{lua_str(script)}] = {{")
        for en, f in utiles:
            lignes.append(f"\t\t{{{lua_str(en)}, {lua_str(f)}}},")
            total += 1
        lignes.append("\t},")
        scripts += 1
    lignes.append("}")
    Path(sys.argv[1]).write_text("\n".join(lignes) + "\n", encoding="utf-8")
    print(f"{sys.argv[1]} : {total} remplacements sur {scripts} scripts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
