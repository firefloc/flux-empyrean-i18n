#!/usr/bin/env python3
"""Ré-indexe une langue par empreinte, pour ne plus embarquer le texte source.

Une traduction se décrit naturellement par des paires « anglais → cible ». Mais
la clé anglaise, c'est le texte du jeu : la publier revient à redistribuer
l'œuvre de son auteur. On remplace donc chaque clé par une empreinte de la
chaîne anglaise, que l'outil recalcule depuis **la copie du jeu du joueur**.

Ça ne rend pas la traduction non dérivée — le texte cible reste une adaptation
et relève de l'accord de l'ayant droit. Ça retire seulement du dépôt la copie
verbatim du texte d'origine.

Usage:
    rekey_locale.py empreinte   # anglais -> empreinte (avant publication)
    rekey_locale.py lisible     # empreinte -> anglais (pour éditer à la main)
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")


def empreinte(texte: str) -> str:
    return "#" + hashlib.sha1(texte.encode("utf-8")).hexdigest()[:16]


def sources_scripts() -> dict[str, list[str]]:
    """Les chaînes anglaises, relues depuis l'extraction de la copie du joueur."""
    brut = json.loads((WORK / "strings_scripts.json").read_text(encoding="utf-8"))
    return {script: [v for vals in lignes.values() for v in vals] for script, lignes in brut.items()}


def sources_clairs() -> list[str]:
    chemin = WORK / "vigenere.json"
    if not chemin.exists():
        return []
    return [d["clair"] for d in json.loads(chemin.read_text(encoding="utf-8")).values()]


def convertir(sens: str) -> int:
    scripts = json.loads((LOCALE / "scripts.json").read_text(encoding="utf-8"))
    conteneur = scripts.get("chaines", scripts)
    table = sources_scripts()
    n = 0
    for script, paires in conteneur.items():
        connues = table.get(script, [])
        index = {empreinte(s): s for s in connues}
        nouveau = {}
        for cle, valeur in paires.items():
            if sens == "empreinte":
                nouveau[cle if cle.startswith("#") else empreinte(cle)] = valeur
            else:
                nouveau[index.get(cle, cle)] = valeur
            n += 1
        conteneur[script] = nouveau
    (LOCALE / "scripts.json").write_text(
        json.dumps(scripts, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )

    clairs = json.loads((LOCALE / "decrypt.json").read_text(encoding="utf-8"))
    index = {empreinte(c): c for c in sources_clairs()}
    converti = {}
    for cle, valeur in clairs.items():
        if sens == "empreinte":
            converti[cle if cle.startswith("#") else empreinte(cle)] = valeur
        else:
            converti[index.get(cle, cle)] = valeur
        n += 1
    (LOCALE / "decrypt.json").write_text(
        json.dumps(converti, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    return n


def main() -> int:
    sens = sys.argv[1] if len(sys.argv) > 1 else ""
    if sens not in ("empreinte", "lisible"):
        raise SystemExit(__doc__)
    n = convertir(sens)
    restantes = sum(
        1
        for paires in json.loads((LOCALE / "scripts.json").read_text(encoding="utf-8"))
        .get("chaines", {})
        .values()
        for cle in paires
        if not cle.startswith("#")
    )
    print(f"langue {LOCALE.name} : {n} clés converties en « {sens} »")
    if sens == "empreinte":
        print(f"  clés encore en clair : {restantes}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
