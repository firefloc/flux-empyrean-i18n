#!/usr/bin/env python3
"""Contrôle qualité d'un lot de traduction avant intégration.

Deux fautes cassent une énigme sans jamais lever d'erreur en jeu :

- traduire un segment chiffré — `Passage.decrypt()` retire les non-lettres puis
  indexe la clé, donc une lettre en trop décale tout le message déchiffré ;
- traduire un token de réponse sans déclarer le terme français retenu — la
  porte ne s'ouvre alors ni en anglais ni en français.

Ce script attrape les deux, plus les ruptures de forme et les noms propres
traduits par mégarde.

Usage: verify_translation.py <traduction.json> [--json <rapport.json>]

Sortie 0 si aucune erreur bloquante, 1 sinon.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def load(name: str) -> dict:
    return json.loads((WORK / name).read_text(encoding="utf-8"))


def body(pages) -> str:
    return "\n".join(pages) if isinstance(pages, list) else str(pages)


def sans_accents(s: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", s) if not unicodedata.combining(c))


class Report:
    def __init__(self) -> None:
        self.errors: list[dict] = []
        self.warnings: list[dict] = []

    def error(self, doc: str, kind: str, detail: str) -> None:
        self.errors.append({"document": doc, "type": kind, "detail": detail})

    def warn(self, doc: str, kind: str, detail: str) -> None:
        self.warnings.append({"document": doc, "type": kind, "detail": detail})


def check_shape(doc, src_pages, fr_pages, frozen, rep: Report) -> None:
    if not isinstance(fr_pages, list):
        rep.error(doc, "forme", "`pages` n'est pas un tableau")
        return
    if len(fr_pages) != len(src_pages):
        rep.error(doc, "forme", f"{len(fr_pages)} pages contre {len(src_pages)} attendues")
    gelees = set(frozen.get(doc, {}))
    for i, (en, fr) in enumerate(zip(src_pages, fr_pages)):
        if not isinstance(fr, str):
            rep.error(doc, "forme", f"page {i} n'est pas une chaîne")
            continue
        if not fr.strip():
            rep.error(doc, "forme", f"page {i} vide")
        elif fr.strip() == en.strip() and str(i) not in gelees:
            rep.warn(doc, "non_traduit", f"page {i} identique à l'anglais")
        if en.count("%s") != fr.count("%s"):
            rep.error(doc, "placeholder", f"page {i} : nombre de %s différent")


def check_frozen(doc, fr_pages, frozen, rep: Report) -> None:
    for page_index, segments in frozen.get(doc, {}).items():
        i = int(page_index)
        if i >= len(fr_pages):
            rep.error(doc, "gele", f"page {i} absente, elle porte un segment gelé")
            continue
        for seg in segments:
            if seg["segment"] not in fr_pages[i]:
                rep.error(
                    doc,
                    "gele",
                    f"page {i} : segment {seg['type']} altéré — « {seg['segment'][:48]}… » "
                    "doit être recopié à l'octet près",
                )


def check_locks(doc, fr_pages, payload, locks, rep: Report) -> None:
    """Chaque token verrouillé enseigné par ce document doit être déclaré.

    Le code accepte désormais les réponses françaises, mais encore faut-il
    savoir lesquelles ajouter : c'est `termes_de_reponse` qui les fournit.
    """
    brut = body(fr_pages).lower()
    texte = sans_accents(brut)
    declares = {k.lower(): v for k, v in (payload.get("termes_de_reponse") or {}).items()}
    for point in locks["points_de_saisie"]:
        acrostiches = set(point.get("tokens_par_acrostiche", []))
        for token, sources in point["documents_source"].items():
            if not isinstance(sources, list) or doc not in sources:
                continue
            # Un token porté par un acrostiche n'est jamais littéralement dans le
            # texte : ce sont les initiales qui l'épellent. Sa protection passe
            # par un alias sur la suite de lettres française, pas par ce contrôle.
            if token.lower() in acrostiches:
                continue
            if token.lower() in brut:
                continue  # le mot anglais a survécu, l'énigme marche telle quelle
            # Piège : `Élysium` passe un test insensible aux accents, mais le jeu
            # compare `to_lower()` sur la saisie brute — « élysium » ≠ « elysium ».
            # Ce n'est acceptable que si le terme accentué est déclaré, donc câblé
            # en alias côté code.
            if token.lower() in texte and not declares.get(token.lower()):
                rep.error(
                    doc,
                    "verrou_accent",
                    f"« {token} » n'apparaît qu'accentué dans le texte français et "
                    "n'est pas déclaré ; le jeu compare sans normaliser, l'énigme "
                    "resterait fermée",
                )
                continue
            terme = declares.get(token.lower())
            if not terme:
                rep.error(
                    doc,
                    "verrou",
                    f"« {token} » a disparu et aucun terme français n'est déclaré "
                    f"dans `termes_de_reponse` (énigme : {point['script']})",
                )
            elif sans_accents(terme.lower()) not in texte:
                rep.error(
                    doc,
                    "verrou",
                    f"« {token} » est déclaré rendu par « {terme} », mais ce terme "
                    "n'apparaît pas dans le texte traduit",
                )


def check_proper_nouns(doc, src_pages, fr_pages, names, rep: Report) -> None:
    en_text, fr_text = body(src_pages), body(fr_pages)
    for name in names:
        if len(name) < 4:
            continue
        pattern = re.compile(r"\b" + re.escape(name) + r"\b", re.I)
        if pattern.search(en_text) and not pattern.search(fr_text):
            rep.warn(doc, "nom_propre", f"« {name} » présent en anglais, absent en français")


def check_glossary_consistency(batch: dict, rep: Report) -> None:
    proposals: dict[str, dict[str, list[str]]] = {}
    for doc, payload in batch.items():
        for en, fr in (payload.get("glossaire_propose") or {}).items():
            proposals.setdefault(en, {}).setdefault(fr, []).append(doc)
    for en, variants in proposals.items():
        if len(variants) > 1:
            detail = " / ".join(f"« {fr} » ({', '.join(d)})" for fr, d in variants.items())
            rep.warn("(lot)", "glossaire", f"« {en} » rendu de plusieurs façons : {detail}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("traduction", type=Path)
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()

    corpus = load("texts_corpus.json")
    locks = load("puzzle_locks.json")
    frozen = load("frozen_segments.json")
    names = set(load("glossary.json")["noms_propres_a_conserver"])
    batch = json.loads(args.traduction.read_text(encoding="utf-8"))

    rep = Report()
    for doc, payload in batch.items():
        if doc not in corpus["texts"]:
            rep.error(doc, "inconnu", "ce titre n'existe pas dans le corpus")
            continue
        src_pages = corpus["texts"][doc]
        fr_pages = payload.get("pages")
        check_shape(doc, src_pages, fr_pages, frozen, rep)
        if isinstance(fr_pages, list):
            check_frozen(doc, fr_pages, frozen, rep)
            check_locks(doc, fr_pages, payload, locks, rep)
            check_proper_nouns(doc, src_pages, fr_pages, names, rep)
    check_glossary_consistency(batch, rep)

    print(f"documents vérifiés : {len(batch)}")
    for label, items in (("ERREUR", rep.errors), ("alerte", rep.warnings)):
        for item in items:
            print(f"  [{label}] {item['document']} — {item['type']} : {item['detail']}")
    print(f"\n{len(rep.errors)} erreur(s) bloquante(s), {len(rep.warnings)} alerte(s)")

    doubts = [
        (doc, d) for doc, payload in batch.items() for d in (payload.get("doutes") or [])
    ]
    if doubts:
        print(f"\n{len(doubts)} doute(s) à arbitrer :")
        for doc, d in doubts:
            print(f"  - {doc} : {d}")

    if args.json:
        args.json.write_text(
            json.dumps(
                {"erreurs": rep.errors, "alertes": rep.warnings, "doutes": doubts},
                ensure_ascii=False,
                indent="\t",
            ),
            encoding="utf-8",
        )
    return 1 if rep.errors else 0


if __name__ == "__main__":
    sys.exit(main())
