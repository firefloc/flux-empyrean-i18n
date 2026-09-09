#!/usr/bin/env python3
"""Prépare le dossier de travail d'un lot de traduction.

Chaque lot est une grappe narrative (documents partageant lieux et noms
propres), pour que la cohérence interne soit acquise sans arbitrage.

Usage: make_batch.py <index du lot, à partir de 1>
Écrit work/lots/lot_<n>/source.json
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def body(pages) -> str:
    return "\n".join(pages) if isinstance(pages, list) else str(pages)


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    index = int(sys.argv[1])

    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    locks = json.loads((WORK / "puzzle_locks.json").read_text(encoding="utf-8"))
    glossary = json.loads((WORK / "glossary.json").read_text(encoding="utf-8"))
    clusters = json.loads((WORK / "clusters.json").read_text(encoding="utf-8"))

    docs = clusters[index - 1]
    documents = {
        d: {
            "pages": corpus["texts"][d],
            "auteur": corpus["authors"].get(d),
        }
        for d in docs
    }

    applicable = []
    for point in locks["points_de_saisie"]:
        touche = {
            tok: src
            for tok, src in point["documents_source"].items()
            if isinstance(src, list) and set(src) & set(docs)
        }
        if touche:
            applicable.append({**point, "documents_source": touche})

    frozen = json.loads((WORK / "frozen_segments.json").read_text(encoding="utf-8"))
    frozen = {d: v for d, v in frozen.items() if d in docs}

    # Les documents extérieurs au lot qui parlent des mêmes entités : contexte
    # de lecture, à ne pas traduire, mais indispensable pour trancher un terme.
    voisins = {}
    entities = {n for n in glossary["noms_propres_a_conserver"] if 3 < len(n) < 30}
    mentioned = {
        n
        for n in entities
        if any(re.search(r"\b" + re.escape(n) + r"\b", body(corpus["texts"][d]), re.I) for d in docs)
    }
    for other, pages in corpus["texts"].items():
        if other in docs:
            continue
        text = body(pages)
        hits = [n for n in mentioned if re.search(r"\b" + re.escape(n) + r"\b", text, re.I)]
        if len(hits) >= 3:
            voisins[other] = sorted(hits)
    # on ne garde que les plus proches : au-delà, c'est du bruit
    voisins = dict(sorted(voisins.items(), key=lambda kv: -len(kv[1]))[:15])

    payload = {
        "lot": index,
        "regimes": locks["regimes"],
        "politique_verrous": (
            "Le code du jeu est patché pour accepter les réponses françaises. "
            "Traduis donc naturellement, sans tordre le texte pour y caser un mot "
            "anglais. En échange, remonte dans `termes_de_reponse` le terme "
            "français que tu as employé pour chaque token verrouillé : c'est lui "
            "qui sera ajouté aux réponses acceptées."
        ),
        "verrous_applicables": applicable,
        "segments_geles": frozen,
        "noms_propres_a_conserver": glossary["noms_propres_a_conserver"],
        "lieux": glossary["lieux"],
        "documents_voisins_pour_contexte": voisins,
        "documents": documents,
    }

    out = WORK / "lots" / f"lot_{index}"
    out.mkdir(parents=True, exist_ok=True)
    (out / "source.json").write_text(
        json.dumps(payload, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    pages = sum(len(v["pages"]) for v in documents.values())
    words = sum(len(body(v["pages"]).split()) for v in documents.values())
    print(
        f"lot {index}: {len(docs)} documents, {pages} pages, {words} mots, "
        f"{len(applicable)} verrou(s), {sum(len(v) for v in frozen.values())} page(s) gelée(s), "
        f"{len(voisins)} voisin(s) de contexte"
    )
    print(f"  -> {out / 'source.json'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
