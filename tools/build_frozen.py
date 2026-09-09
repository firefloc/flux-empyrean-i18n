#!/usr/bin/env python3
"""Recense les segments de texte qui doivent rester à l'octet près.

Le joueur saisit lui-même une clé dans le journal, et `Passage.decrypt()`
applique un Vigenère à la page affichée après avoir retiré tout ce qui n'est
pas une lettre. **Une seule lettre ajoutée ou retirée décale tout le message
déchiffré.** Traduire un bloc chiffré le rend donc définitivement illisible.

Même verdict pour la langue construite (xérétique) et les jeux d'écriture
(leet, mots inversés) : ce sont des énigmes de déchiffrement, pas du texte.

Le doute profite au gel : un segment gelé à tort laisse une ligne en anglais,
un segment traduit à tort casse une énigme sans message d'erreur.

Usage: build_frozen.py
"""

from __future__ import annotations

import collections
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
JEU = ROOT / "game"

# Cas relevés à la main après lecture, que l'heuristique laisse passer :
# rébus en leet, mots inversés, et la langue xérétique — dont le déchiffrement
# est lui-même une énigme (les réponses « minos » et « sarnsan » en sortent).


def build_vocabulary(corpus: dict) -> collections.Counter:
    """Vocabulaire anglais du jeu, tiré du corpus lui-même.

    Meilleur discriminant qu'une liste de mots outils : les mots d'un bloc
    chiffré ou d'une langue construite n'apparaissent nulle part ailleurs,
    alors que « none could truly conquer » se retrouve partout.
    """
    counter: collections.Counter = collections.Counter()
    for pages in corpus["texts"].values():
        for page in pages:
            for w in re.findall(r"[A-Za-z']+", page):
                counter[w.lower()] += 1
    return counter


def classify(line: str, vocab: collections.Counter) -> str | None:
    letters = re.findall(r"[A-Za-z]", line)
    words = [w.lower() for w in re.findall(r"[A-Za-z']+", line)]
    if len(letters) < 12 or not words:
        return None
    upper_run = sum(1 for c in letters if c.isupper()) / len(letters)
    # Un bloc Vigenère est souvent un seul « mot » de cent lettres : le compte
    # de mots ne veut rien dire, seule la masse de capitales compte. Le seuil
    # est bas volontairement — le plus court du jeu fait 23 lettres, et un seuil
    # à 30 le laissait passer.
    if upper_run > 0.7 and len(letters) >= 20 and max(len(w) for w in words) >= 15:
        return "chiffre_vigenere"
    if len(words) < 3:
        return None
    # Part des mots qui vivent ailleurs dans le corpus. Un mot d'une ligne
    # chiffrée n'y apparaît que par lui-même, d'où le seuil à 3.
    connus = sum(1 for w in words if vocab[w] >= 3) / len(words)
    if connus >= 0.35:
        return None

    upper_ratio = sum(1 for c in letters if c.isupper()) / len(letters)
    if upper_ratio > 0.7 and len(letters) >= 30:
        return "chiffre_vigenere"
    if re.search(r"[A-Za-z][0-9]|[0-9][A-Za-z]", line):
        return "jeu_d_ecriture"
    return "langue_construite"


def main() -> None:
    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    vocab = build_vocabulary(corpus)
    frozen: dict[str, dict[str, list[dict]]] = {}
    for doc, pages in corpus["texts"].items():
        for i, page in enumerate(pages):
            for line in page.split("\n"):
                s = line.strip()
                kind = classify(s, vocab)
                if kind:
                    frozen.setdefault(doc, {}).setdefault(str(i), []).append(
                        {"type": kind, "segment": s}
                    )

    manuels = json.loads((JEU / "frozen_manual.json").read_text(encoding="utf-8"))
    for doc, pages in manuels.items():
        for page_index, kind in pages.items():
            page = corpus["texts"][doc][int(page_index)]
            deja = {s["segment"] for s in frozen.get(doc, {}).get(page_index, [])}
            for line in page.split("\n"):
                s = line.strip()
                if s and s not in deja:
                    frozen.setdefault(doc, {}).setdefault(page_index, []).append(
                        {"type": kind, "segment": s, "releve": "manuel"}
                    )

    (WORK / "frozen_segments.json").write_text(
        json.dumps(frozen, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    total = sum(len(v) for d in frozen.values() for v in d.values())
    kinds: dict[str, int] = {}
    for d in frozen.values():
        for segs in d.values():
            for s in segs:
                kinds[s["type"]] = kinds.get(s["type"], 0) + 1
    print(f"documents concernés : {len(frozen)} | segments gelés : {total} | {kinds}")
    for doc, pages in frozen.items():
        for p, segs in pages.items():
            for s in segs:
                print(f"  [{s['type']:17s}] {doc} p.{p} :: {s['segment'][:64]}")


if __name__ == "__main__":
    main()
