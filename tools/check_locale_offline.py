#!/usr/bin/env python3
"""Contrôles d'une langue qui ne demandent pas la copie du jeu.

`verify_locale.py` est plus complet, mais il a besoin du relevé extrait du jeu
— impossible sur un serveur d'intégration continue, puisqu'on ne distribue pas
le jeu. Ce script vérifie donc ce qui se contrôle sur les seuls fichiers de
langue : forme, cohérence interne, et les règles d'écriture qui ont déjà cassé
la traduction par le passé.

Usage: check_locale_offline.py   (langue via LOCALE)
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")


def main() -> int:
    if not LOCALE.is_dir():
        print(f"langue inconnue : {LOCALE}")
        return 1
    erreurs: list[str] = []

    for nom in ("documents.json", "scenes.json", "scripts.json"):
        chemin = LOCALE / nom
        if not chemin.exists():
            erreurs.append(f"{nom} manquant")
            continue
        try:
            json.loads(chemin.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            erreurs.append(f"{nom} : JSON invalide — {e}")

    if erreurs:
        for e in erreurs:
            print(f"  [ERREUR] {e}")
        return 1

    documents = json.loads((LOCALE / "documents.json").read_text(encoding="utf-8"))
    scripts = json.loads((LOCALE / "scripts.json").read_text(encoding="utf-8"))
    scripts = scripts.get("chaines", scripts)

    # Forme des documents : `pages` doit être un tableau de chaînes non vides.
    for titre, charge in documents.items():
        pages = charge.get("pages") if isinstance(charge, dict) else None
        if not isinstance(pages, list) or not pages:
            erreurs.append(f"{titre} : `pages` absent ou vide")
            continue
        for i, page in enumerate(pages):
            if not isinstance(page, str):
                erreurs.append(f"{titre} p{i} : la page n'est pas une chaîne")

    # Chaînes de code : un guillemet droit ou un saut de ligne brut casse le
    # littéral GDScript, et le patch est alors ignoré sans erreur en jeu.
    for script, paires in scripts.items():
        for cle, valeur in paires.items():
            if not isinstance(valeur, str):
                erreurs.append(f"{script} : la traduction de {cle} n'est pas une chaîne")
                continue
            if '"' in valeur:
                erreurs.append(f"{script} : « {valeur[:44]}… » contient un guillemet droit")
            if "\n" in valeur:
                erreurs.append(f"{script} : « {valeur[:44]}… » contient un saut de ligne brut")
        # Les clés doivent être des empreintes : le dépôt ne porte pas le texte source.
        en_clair = [c for c in paires if not c.startswith("#")]
        if en_clair:
            erreurs.append(
                f"{script} : {len(en_clair)} clé(s) en texte anglais — "
                "lance `tools/rekey_locale.py empreinte` avant de proposer la PR"
            )

    if erreurs:
        print(f"langue {LOCALE.name} : {len(erreurs)} problème(s)\n")
        for e in erreurs:
            print(f"  [ERREUR] {e}")
        return 1
    print(f"langue {LOCALE.name} : forme et règles d'écriture correctes")
    print("  (les contrôles d'énigmes demandent la copie du jeu : `build.py` en local)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
