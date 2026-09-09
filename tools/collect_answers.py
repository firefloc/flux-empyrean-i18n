#!/usr/bin/env python3
"""Alimente la table d'alias avec les termes français choisis par les traducteurs.

Chaque lot déclare, dans `termes_de_reponse`, le mot français qu'il a employé
pour chaque token verrouillé. C'est ce mot qu'il faut ajouter aux réponses
acceptées par le jeu — sinon le joueur lit « motifs » et doit taper
« patterns ».

Les déclarations en identité (le terme français est le token anglais, cas des
noms propres) sont ignorées : il n'y a rien à patcher.

Usage: collect_answers.py [--ecrire]
Sans `--ecrire`, affiche seulement ce qui changerait.
"""

from __future__ import annotations

import argparse
import json
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"

# Ajouts qu'aucun traducteur ne peut deviner depuis son lot : l'initiale de
# l'affirmative change de langue (« yes » → « o »), et les formes fléchies.
MANUELS = {
    "yes": ["oui", "o"],
    "no": ["non"],
    "true": ["vrai", "v"],
    "false": ["faux", "f"],
}


def sans_accents(s: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", s) if not unicodedata.combining(c))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ecrire", action="store_true")
    args = parser.parse_args()

    fichier = WORK / "answer_aliases.json"
    aliases: dict[str, list[str]] = json.loads(fichier.read_text(encoding="utf-8"))
    for token, formes in MANUELS.items():
        aliases.setdefault(token, [])
        for f in formes:
            if f not in aliases[token]:
                aliases[token].append(f)

    ajouts: list[str] = []
    for chemin in sorted(WORK.glob("lots/lot_*/traduction.json")) + sorted(
        WORK.glob("pilote/traduction.json")
    ):
        batch = json.loads(chemin.read_text(encoding="utf-8"))
        for doc, payload in batch.items():
            for token, terme in (payload.get("termes_de_reponse") or {}).items():
                if not isinstance(terme, str) or not terme.strip():
                    continue
                t, f = token.lower(), terme.strip().lower()
                if f == t:
                    continue  # identité : nom propre non traduit, rien à patcher
                aliases.setdefault(t, [])
                for variante in {f, sans_accents(f)}:
                    if variante not in aliases[t]:
                        aliases[t].append(variante)
                        ajouts.append(f"{t} += « {variante} »  ({chemin.parent.name}, {doc})")

    aliases = {k: sorted(set(v)) for k, v in aliases.items() if v}
    if args.ecrire:
        fichier.write_text(
            json.dumps(aliases, ensure_ascii=False, indent="\t"), encoding="utf-8"
        )
    print(f"tokens avec alias : {len(aliases)} | ajouts : {len(ajouts)}")
    for a in ajouts:
        print("  " + a)
    if not args.ecrire:
        print("\n(simulation — relance avec --ecrire pour appliquer)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
