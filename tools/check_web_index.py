#!/usr/bin/env python3
"""Refuse de publier la page si elle embarque du texte du jeu.

C'est la promesse centrale du projet : le dépôt et la page ne contiennent aucune
prose de ChillCash. Le texte anglais vient du pack du joueur, lu dans son
navigateur. `build_index_web.py` le vérifie déjà au moment de générer, mais il a
besoin du corpus pour ça — donc il ne peut pas tourner en intégration continue,
qui n'a pas le jeu.

Ce contrôle-ci s'en passe, en raisonnant sur la **forme** plutôt que sur le
contenu. Les quatre fichiers générés ne doivent porter que des empreintes, des
nombres et des chemins de ressources ; rien qui ressemble à une phrase.

Les deux fichiers tenus à la main — `verrous.json` et `gel_manuel.json` —
échappent à la règle : ils décrivent la logique du jeu et portent nos propres
notes en français, qui sont longues par nature. Ils sont contrôlés autrement :
aucune de leurs valeurs ne doit être une phrase anglaise.

Usage: check_web_index.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

INDEX = Path(__file__).resolve().parent.parent / "web" / "index"

# Ces quatre-là sortent de `build_index_web.py` : que des empreintes, des
# nombres et des chemins `res://`.
GENERES = ("documents.json", "scripts.json", "scenes.json", "ponts.json")

# Ce qu'une carte a le droit de contenir : une empreinte, un nombre, un chemin de
# ressource ou de script — espaces compris, le jeu en met dans ses dossiers —, ou
# le nom d'un champ. Rien d'autre : surtout pas une phrase.
INOFFENSIF = re.compile(
    r"^(#[0-9a-f]{16}"                       # une empreinte
    r"|\d+"                                  # un indice de nœud ou de page
    r"|res://[\w /.-]+"                      # un chemin de ressource Godot
    r"|[\w /.-]+\.(gdc|tscn|gd|scn)"         # un chemin de script ou de scène
    r"|[a-z_]+"                              # un nom de champ, en snake_case
    r")$"
)

# Une phrase anglaise : plusieurs mots courants de l'anglais à la suite. On
# cherche la prose du jeu, pas un mot-réponse isolé comme « immortal », qui a
# toute sa place dans `verrous.json`.
ANGLAIS = re.compile(
    r"\b(the|and|of|that|with|from|which|there|their|would|been|were|this)\b.{0,60}?"
    r"\b(the|and|of|that|with|from|which|there|their|would|been|were|this)\b",
    re.IGNORECASE,
)


def valeurs(noeud, chemin=""):
    """Toutes les chaînes d'un JSON, avec le chemin qui y mène."""
    if isinstance(noeud, dict):
        for cle, valeur in noeud.items():
            yield from valeurs(cle, chemin)
            yield from valeurs(valeur, f"{chemin} › {cle}" if chemin else str(cle))
    elif isinstance(noeud, list):
        for element in noeud:
            yield from valeurs(element, chemin)
    elif isinstance(noeud, str):
        yield chemin, noeud


def main() -> None:
    fautes: list[str] = []

    for nom in GENERES:
        fichier = INDEX / nom
        if not fichier.exists():
            fautes.append(f"{nom} : absent — la page ne pourra pas lire le pack du joueur")
            continue
        for chemin, valeur in valeurs(json.loads(fichier.read_text(encoding="utf-8"))):
            if not INOFFENSIF.match(valeur):
                fautes.append(f"{nom} [{chemin}] : « {valeur[:60]} » n'est ni une empreinte ni un chemin")

    for nom in ("verrous.json", "gel_manuel.json"):
        fichier = INDEX / nom
        if not fichier.exists():
            continue
        for chemin, valeur in valeurs(json.loads(fichier.read_text(encoding="utf-8"))):
            if len(valeur) > 40 and ANGLAIS.search(valeur):
                fautes.append(f"{nom} [{chemin}] : phrase anglaise — « {valeur[:60]} »")

    if fautes:
        print(f"web/index/ : {len(fautes)} problème(s)\n", file=sys.stderr)
        for f in fautes:
            print(f"  [REFUS] {f}", file=sys.stderr)
        print(
            "\nLa page ne doit embarquer aucun texte du jeu : le joueur le lit dans sa "
            "propre copie.",
            file=sys.stderr,
        )
        raise SystemExit(1)

    total = sum(1 for nom in GENERES for _ in valeurs(json.loads((INDEX / nom).read_text(encoding="utf-8"))))
    print(f"web/index/ : {total} valeurs contrôlées, aucune n'est du texte du jeu")


if __name__ == "__main__":
    main()
