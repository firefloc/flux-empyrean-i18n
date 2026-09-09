#!/usr/bin/env python3
"""Construit le glossaire de référence, en lecture seule pour les traducteurs.

Un nom propre est un mot qui n'apparaît **jamais** en minuscules ailleurs dans
le corpus. Sans ce test, tout mot de début de phrase (« Many », « Perhaps »,
« Well ») se retrouve classé nom propre, et le contrôle qualité crie au loup à
chaque page.

Usage: build_glossary.py
"""

from __future__ import annotations

import collections
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def main() -> None:
    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    locations = sorted(p.name for p in (WORK / "extract" / "Locations").iterdir())

    # Une majuscule en début de phrase ne prouve rien. Seule compte la majuscule
    # au milieu d'une phrase : c'est elle qui distingue « Ayodhia » de « Alas ».
    milieu: collections.Counter = collections.Counter()
    minuscule: collections.Counter = collections.Counter()
    for pages in corpus["texts"].values():
        for page in pages:
            for m in re.finditer(r"[A-Za-z][A-Za-z'-]+", page):
                w = m.group()
                if not w[0].isupper():
                    minuscule[w.lower()] += 1
                    continue
                avant = page[: m.start()].rstrip()
                if avant and not avant.endswith((".", "!", "?", ":", '"', "\n")):
                    milieu[w.lower()] += 1

    noms_propres = {
        w
        for w, n in milieu.items()
        if n >= 2 and minuscule[w] == 0 and len(w) > 2 and not w.startswith("i'")
    }
    # forme d'origine, capitalisation comprise
    formes = {}
    for pages in corpus["texts"].values():
        for page in pages:
            for w in re.findall(r"[A-Za-z][A-Za-z'-]+", page):
                if w.lower() in noms_propres and w[0].isupper():
                    formes.setdefault(w.lower(), w)

    recurrents = [
        {"terme": w, "occurrences": n, "decision": "A TRANCHER"}
        for w, n in minuscule.most_common(400)
        if len(w) > 4 and n >= 12
    ][:60]

    glossaire = {
        "regle": "Lecture seule pour les agents traducteurs : ils proposent des "
                 "ajouts dans `glossaire_propose`, ils ne modifient jamais ce fichier.",
        "noms_propres_a_conserver": sorted(
            set(formes.values()) | set(locations) | set(corpus["texts"]) | set(corpus["authors"].values())
        ),
        "termes_recurrents": recurrents,
        "lieux": locations,
    }
    (WORK / "glossary.json").write_text(
        json.dumps(glossaire, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(
        f"noms propres : {len(glossaire['noms_propres_a_conserver'])} "
        f"(dont {len(formes)} tirés du texte, {len(locations)} lieux) | "
        f"termes récurrents à trancher : {len(recurrents)}"
    )
    print("échantillon noms propres :", sorted(formes.values())[:20])


if __name__ == "__main__":
    main()
