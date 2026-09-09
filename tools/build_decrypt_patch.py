#!/usr/bin/env python3
"""Ajoute une traduction française sous le clair déchiffré des blocs Vigenère.

Le joueur saisit une clé dans le journal, `Passage.decrypt()` déchiffre la page
affichée — et lui rend de l'anglais. Refabriquer un chiffré français est exclu :
ça invaliderait les clés, qui sont des noms propres du jeu et servent d'énigme
à elles seules.

L'arbitrage retenu est donc l'**ajout** : le clair anglais reste intact, la
traduction s'affiche dessous. Deux des six clairs sont des consignes de
navigation, pas du lore — un joueur francophone qui déchiffre une instruction
qu'il ne comprend pas a résolu l'énigme pour rien.

La table est indexée par le clair déchiffré lui-même, pas par le document : le
joueur peut tenter n'importe quelle clé sur n'importe quelle page, et seule la
bonne produit une entrée connue.

Usage: build_decrypt_patch.py
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")

# Clair déchiffré (lettres seules, majuscules) -> traduction française.

AVANT = "\t\t\t$RichTextLabel.text = decrypt(text, key)"

APRES = """\t\t\tvar clair := decrypt(text, key)
\t\t\tvar traduction: String = FR_CLAIRS.get(clair, "")
\t\t\tif traduction.is_empty():
\t\t\t\t$RichTextLabel.text = clair
\t\t\telse:
\t\t\t\t$RichTextLabel.text = clair + "\\n\\n" + traduction"""

AIDE = """


const FR_CLAIRS := {table}
"""


def gd_str(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def main() -> None:
    brutes = json.loads((LOCALE / "decrypt.json").read_text(encoding="utf-8"))
    # Les clés sont des empreintes du clair déchiffré ; le clair lui-même vient
    # de la copie du joueur, jamais du dépôt.
    clairs = json.loads((WORK / "vigenere.json").read_text(encoding="utf-8"))
    index = {"#" + hashlib.sha1(d["clair"].encode()).hexdigest()[:16]: d["clair"]
             for d in clairs.values()}
    traductions = {}
    for cle, valeur in brutes.items():
        anglais = index.get(cle, cle if not cle.startswith("#") else None)
        if anglais:
            traductions[anglais] = valeur
    lignes = ["{"]
    for clair, fr in traductions.items():
        lignes.append(f"\t{gd_str(clair)}: {gd_str(fr)},")
    lignes.append("}")
    table = "\n".join(lignes)

    sortie = {
        "remplacements": {"Scripts/passage.gdc": [[AVANT, APRES]]},
        "aides": {"Scripts/passage.gdc": AIDE.format(table=table)},
    }
    (WORK / "decrypt_patch.json").write_text(
        json.dumps(sortie, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(f"decrypt_patch.json : {len(traductions)} clairs traduits")
    for clair in traductions:
        print(f"  {len(clair):4d} lettres  {clair[:52]}…")


if __name__ == "__main__":
    main()
