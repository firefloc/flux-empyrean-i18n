#!/usr/bin/env python3
"""Déchiffre les blocs Vigenère du jeu, à partir des clés connues.

`Passage.decrypt()` retire tout ce qui n'est pas une lettre avant d'appliquer
la clé — on reproduit exactement ce traitement, sinon le clair est décalé.

Les clés vivent dans `game/vigenere_keys.json` : ce sont des faits du jeu, pas
des données de langue. Le clair obtenu sert de clé de traduction dans
`locales/<code>/decrypt.json`, sous forme d'empreinte, pour que le dépôt ne
contienne pas le texte anglais.

Usage: crack_vigenere.py
Écrit work/vigenere.json
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
JEU = ROOT / "game"


def lettres(texte: str) -> str:
    return "".join(c for c in texte.upper() if c.isalpha())


def dechiffre(texte: str, cle: str) -> str:
    t, k = lettres(texte), lettres(cle)
    if not k:
        return t
    return "".join(
        chr((ord(t[i]) - 65 - (ord(k[i % len(k)]) - 65)) % 26 + 65) for i in range(len(t))
    )


def main() -> None:
    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))["texts"]
    cles = json.loads((JEU / "vigenere_keys.json").read_text(encoding="utf-8"))["cles"]
    sortie = {}
    for doc, pages in cles.items():
        if doc not in corpus:
            print(f"  document absent de cette build : {doc}")
            continue
        for index, cle in pages.items():
            i = int(index)
            if i >= len(corpus[doc]):
                print(f"  page absente : {doc} p{i}")
                continue
            clair = dechiffre(corpus[doc][i], cle)
            sortie[f"{doc}|{i}"] = {"cle": cle, "clair": clair}
    (WORK / "vigenere.json").write_text(
        json.dumps(sortie, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(f"blocs déchiffrés : {len(sortie)}")


if __name__ == "__main__":
    main()
