#!/usr/bin/env python3
"""Détecte les acrostiches et signale ceux que la traduction a perdus.

Le jeu cache des clés dans les initiales : celles des pages d'un document, ou
celles des mots d'une ligne. `Witness` dit d'ailleurs la règle en clair — « the
key for passage is the first letter of each passage ». Trois documents en
portent un, et aucun n'était détectable par les outils qui cherchent des
comparaisons de chaînes : l'acrostiche ne ressemble à rien dans le texte.

Deux sorties :

- les acrostiches anglais qui **sont** une réponse d'énigme — à protéger ;
- ceux que la traduction a modifiés — à réparer, soit en reconstruisant
  l'acrostiche en français, soit en acceptant la nouvelle suite comme alias.

Usage: check_acrostics.py
"""

from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def pliable(s: str) -> str:
    return "".join(
        c for c in unicodedata.normalize("NFD", s) if not unicodedata.combining(c)
    ).lower()


def initiale(texte: str) -> str:
    m = re.search(r"[A-Za-zÀ-ÿ]", texte)
    return pliable(m.group()) if m else ""


def acrostiches(pages: list[str]) -> dict[str, str]:
    """Les trois découpages que le jeu utilise : pages, phrases, mots."""
    out = {"pages": "".join(initiale(p) for p in pages)}
    phrases = [s for p in pages for s in re.split(r"(?<=[.!?])\s+", p) if s.strip()]
    out["phrases"] = "".join(initiale(s) for s in phrases)
    lignes = []
    for p in pages:
        for ligne in p.split("\n"):
            mots = ligne.split()
            if len(mots) >= 3:
                lignes.append("".join(initiale(m) for m in mots))
    out["mots_par_ligne"] = " ".join(lignes)
    return out


def main() -> None:
    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    locks = json.loads((WORK / "puzzle_locks.json").read_text(encoding="utf-8"))
    tokens = {
        t.lower()
        for p in locks["points_de_saisie"]
        for t in p["tokens"]
        if len(t) >= 4 and not t.isdigit()
    }

    # La traduction de la langue en cours, telle que `locale_to_work.py` vient de
    # la déposer. On lisait auparavant les lots de traduction française laissés
    # dans `work/` — ce qui revenait à contrôler le français quelle que soit la
    # langue demandée, et faisait échouer toute langue neuve sur un acrostiche
    # qui n'était pas le sien.
    traductions: dict[str, list[str]] = {}
    courante = WORK / "translation_texts.json"
    if courante.exists():
        données = json.loads(courante.read_text(encoding="utf-8"))
        for doc, payload in données.get("texts", données).items():
            pages = payload if isinstance(payload, list) else payload.get("pages", [])
            if any(pages):
                traductions[doc] = pages

    porteurs, casses = [], []
    for doc, pages in corpus["texts"].items():
        en = acrostiches(pages)
        for decoupage, valeur in en.items():
            for tok in tokens:
                if tok in valeur:
                    porteurs.append((doc, decoupage, tok))
        if doc not in traductions:
            continue
        fr = acrostiches(traductions[doc])
        for decoupage in ("pages", "phrases"):
            if len(en[decoupage]) >= 5 and en[decoupage] != fr[decoupage]:
                casses.append((doc, decoupage, en[decoupage], fr[decoupage]))

    print(f"documents analysés : {len(corpus['texts'])} | traduits : {len(traductions)}\n")
    print("=== acrostiches qui sont une réponse d'énigme ===")
    for doc, decoupage, tok in porteurs or []:
        print(f"  {doc} ({decoupage}) porte « {tok} »")
    if not porteurs:
        print("  aucun")
    print("\n=== acrostiches de pages modifiés par la traduction ===")
    interessants = [c for c in casses if c[1] == "pages"]
    for doc, _, en_v, fr_v in interessants:
        marque = "  ⚠ PORTE UNE RÉPONSE" if any(t in en_v for t in tokens) else ""
        print(f"  {doc} : {en_v} -> {fr_v}{marque}")
    print(f"\n{len(interessants)} acrostiche(s) de pages modifié(s)")


if __name__ == "__main__":
    main()
