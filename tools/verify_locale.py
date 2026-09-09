#!/usr/bin/env python3
"""Contrôle une langue entière avant de construire le mod.

C'est le garde-fou qui fait la valeur de cet outil. Une traduction de ce jeu
peut casser des énigmes sans qu'aucune erreur ne se lève en jeu :

- un bloc chiffré retouché d'une seule lettre devient indéchiffrable ;
- un mot-réponse traduit sans déclarer son équivalent ferme une porte pour
  toujours ;
- un guillemet droit dans une chaîne de code empêche le script de compiler, et
  le patch est alors ignoré en silence ;
- un acrostiche perdu emporte la clé qu'il épelait.

Ce script refuse de laisser passer ces quatre cas.

Usage: verify_locale.py   (langue via la variable LOCALE, `fr` par défaut)
Sortie 0 si la langue est constructible, 1 sinon.
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")


def sans_accents(s: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", s) if not unicodedata.combining(c))


def main() -> int:
    erreurs: list[str] = []
    documents = json.loads((LOCALE / "documents.json").read_text(encoding="utf-8"))
    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    frozen = json.loads((WORK / "frozen_segments.json").read_text(encoding="utf-8"))
    locks = json.loads((WORK / "puzzle_locks.json").read_text(encoding="utf-8"))

    # 1. Forme des documents et segments gelés recopiés à l'octet près.
    for titre, charge in documents.items():
        pages = charge.get("pages") if isinstance(charge, dict) else None
        if titre not in corpus["texts"]:
            erreurs.append(f"document inconnu du jeu : {titre}")
            continue
        source = corpus["texts"][titre]
        if not isinstance(pages, list) or len(pages) != len(source):
            erreurs.append(
                f"{titre} : {len(pages) if isinstance(pages, list) else '?'} pages "
                f"au lieu de {len(source)}"
            )
            continue
        for index, segments in frozen.get(titre, {}).items():
            i = int(index)
            for seg in segments:
                if seg["segment"] not in pages[i]:
                    erreurs.append(
                        f"{titre} p{i} : segment {seg['type']} altéré "
                        f"(« {seg['segment'][:40]}… »)"
                    )

    # 2. Mots-réponses : présents tels quels, ou déclarés dans termes_de_reponse.
    for point in locks["points_de_saisie"]:
        acrostiches = set(point.get("tokens_par_acrostiche", []))
        for token, sources in point["documents_source"].items():
            if not isinstance(sources, list) or token.lower() in acrostiches:
                continue
            for titre in sources:
                charge = documents.get(titre)
                if not isinstance(charge, dict) or not charge.get("pages"):
                    continue
                texte = "\n".join(charge["pages"]).lower()
                if token.lower() in texte:
                    continue
                terme = (charge.get("termes_de_reponse") or {}).get(token, "")
                if not terme:
                    erreurs.append(
                        f"{titre} : le mot-réponse « {token} » a disparu et aucun "
                        f"équivalent n'est déclaré dans termes_de_reponse "
                        f"(énigme : {point['script']})"
                    )
                elif sans_accents(terme.lower()) not in sans_accents(texte):
                    erreurs.append(
                        f"{titre} : « {token} » déclaré rendu par « {terme} », "
                        "mais ce terme n'apparaît pas dans le texte"
                    )

    # 3. Chaînes de code : pas de guillemet droit ni de saut de ligne brut.
    scripts = json.loads((LOCALE / "scripts.json").read_text(encoding="utf-8"))
    scripts = scripts.get("chaines", scripts)
    for script, paires in scripts.items():
        for anglais, traduit in paires.items():
            if traduit and traduit != anglais and ('"' in traduit or "\n" in traduit):
                erreurs.append(
                    f"{script} : « {traduit[:50]}… » contient un guillemet droit ou "
                    "un saut de ligne brut, ce qui casserait le littéral GDScript"
                )

    # 4. Acrostiches porteurs d'une réponse. Un acrostiche peut changer — le
    #    français n'épellera pas les mêmes initiales — à condition que la
    #    nouvelle suite soit déclarée comme réponse acceptée.
    alias = json.loads((LOCALE / "aliases.json").read_text(encoding="utf-8"))
    # `check_acrostics.py` lit `work/`, alimenté par la dernière langue traitée.
    # Sans ce rafraîchissement, contrôler une langue revenait à analyser la
    # précédente — et une langue neuve échouait sur l'acrostiche du français.
    subprocess.run(
        [sys.executable, str(ROOT / "tools" / "locale_to_work.py")],
        capture_output=True, text=True, check=True,
    )
    sortie = subprocess.run(
        [sys.executable, str(ROOT / "tools" / "check_acrostics.py")],
        capture_output=True, text=True,
    ).stdout
    for ligne in sortie.splitlines():
        if "PORTE UNE RÉPONSE" not in ligne:
            continue
        m = re.search(r"^\s*(.+?)\s*:\s*(\S+)\s*->\s*(\S+)", ligne)
        if not m:
            erreurs.append(f"acrostiche porteur non analysable : {ligne.strip()}")
            continue
        doc, avant, apres = m.groups()
        couvert = any(
            apres in [a.lower() for a in valeurs]
            for token, valeurs in alias.items()
            if token.lower() in avant
        )
        if not couvert:
            erreurs.append(
                f"{doc} : l'acrostiche « {avant} » devient « {apres} » et n'est pas "
                "déclaré comme réponse acceptée dans aliases.json — l'énigme "
                "deviendrait insoluble"
            )

    if erreurs:
        print(f"langue {LOCALE.name} : {len(erreurs)} problème(s) bloquant(s)\n")
        for e in erreurs:
            print(f"  [ERREUR] {e}")
        return 1
    print(f"langue {LOCALE.name} : aucun problème bloquant")
    return 0


if __name__ == "__main__":
    sys.exit(main())
