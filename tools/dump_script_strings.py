#!/usr/bin/env python3
"""Relève toutes les chaînes affichables noyées dans le code du jeu.

Deux familles, et il faut les deux :

- la **prose** — descriptions de lieux, lore des factions, messages longs. Trois
  mots au minimum, ce qui suffit à écarter les identifiants ;
- les **libellés courts** assignés à une propriété d'affichage : `.text = "OFF"`,
  `"RG-Shift: %s"`, `"By %s"`. Le premier relevé les écartait tous, et c'est
  précisément ce que le joueur a sous les yeux en permanence.

Usage: dump_script_strings.py
Écrit work/strings_scripts.json
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
SRC = WORK / "src"

LITTERAL = re.compile(r'"((?:[^"\\]|\\.)*)"')
AFFICHAGE = re.compile(r'\.(?:text|placeholder_text|tooltip_text)\s*=\s*"((?:[^"\\]|\\.)+)"')
TECHNIQUE = re.compile(
    r'^(res|user)://|\.(gd|gdc|tscn|scn|png|ogg|wav|res|tres|json)$|^[a-z_]+$|^[A-Z][A-Za-z0-9]*$'
)
# Greffons d'éditeur : jamais affichés au joueur.
GREFFONS = ("addons/godotsteam", "addons/meshmerge")


def prose(ligne: str) -> list[str]:
    out = []
    for m in LITTERAL.finditer(ligne):
        s = m.group(1)
        if len(s) < 12 or TECHNIQUE.search(s):
            continue
        mots = s.split()
        if len(mots) >= 3 and any(w[:1].islower() for w in mots):
            out.append(s)
    return out


def libelles(ligne: str) -> list[str]:
    return [m.group(1) for m in AFFICHAGE.finditer(ligne) if re.search(r"[A-Za-z]{2}", m.group(1))]


def main() -> None:
    table: dict[str, dict[str, list[str]]] = {}
    total = 0
    for fichier in sorted(SRC.glob("*.gd")):
        if fichier.name == "Scripts__texts.gd":
            continue  # le corpus a son propre circuit
        script = fichier.name.replace("__", "/").replace(".gd", ".gdc")
        if any(g in script for g in GREFFONS):
            continue
        entrees: dict[str, list[str]] = {}
        for numero, ligne in enumerate(
            fichier.read_text(encoding="utf-8", errors="replace").splitlines(), 1
        ):
            if ligne.lstrip().startswith("#"):
                continue
            trouvees = prose(ligne) + libelles(ligne)
            uniques = list(dict.fromkeys(trouvees))
            if uniques:
                entrees[str(numero)] = uniques
                total += len(uniques)
        if entrees:
            table[script] = entrees

    (WORK / "strings_scripts.json").write_text(
        json.dumps(table, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(f"scripts : {len(table)} | chaînes affichables : {total}")


if __name__ == "__main__":
    main()
