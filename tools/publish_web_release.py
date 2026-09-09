#!/usr/bin/env python3
"""Publie un mod construit dans la page web, pour que le joueur l'y installe.

Le joueur ne doit ouvrir aucun terminal. La page sait déjà lire son jeu ; il lui
manquait le mod à poser. Plutôt que de le lui faire fabriquer dans le
navigateur — ce qui supposerait de porter tout l'outillage en JavaScript — on
publie le mod construit à côté de la page, et elle se contente de l'écrire dans
le dossier du jeu.

C'est possible parce que le mod ne contient **aucun fichier du jeu** : cinq
fichiers de texte et de Lua, 220 Ko. Les scènes traduites, elles, sont
fabriquées par le jeu lui-même au premier lancement, depuis la copie du joueur.

Le manifeste sert à la page : elle n'a pas de listing de dossier, il lui faut la
liste des fichiers et leur taille pour savoir quoi chercher et quoi annoncer.

Usage: publish_web_release.py [<code de langue> ...]     (défaut : toutes celles construites)
"""

from __future__ import annotations

import hashlib
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / "build"
SORTIE = ROOT / "web" / "releases"
LOCALES = ROOT / "locales"
# Les fichiers de langue eux-mêmes, pour que l'éditeur puisse les charger sans
# qu'un contributeur ait à aller les chercher dans le dépôt. Ce sont les mêmes
# que ceux d'une pull request : source de vérité, pas le mod construit.
SORTIE_LANGUES = ROOT / "web" / "locales"
EDITABLES = ("documents.json", "scenes.json", "scripts.json", "aliases.json")


def compter(code: str) -> tuple[int, int]:
    """Ce qui est traduit sur ce qui reste à faire, pour situer un contributeur."""
    fichier = LOCALES / code / "documents.json"
    if not fichier.exists():
        return 0, 0
    documents = json.loads(fichier.read_text(encoding="utf-8"))
    pages = [p for d in documents.values() for p in d.get("pages", [])]
    return sum(1 for p in pages if p.strip()), len(pages)


def publier_langue(code: str) -> dict:
    """Rend une langue éditable, qu'elle soit commencée ou non.

    Une langue vide a autant sa place ici qu'une langue finie : c'est même le
    seul moyen pour quelqu'un de s'y mettre. Le squelette porte déjà la
    checklist des mots-réponses, qui est ce qu'on aurait aimé avoir au départ.
    """
    editables = SORTIE_LANGUES / code
    if editables.exists():
        shutil.rmtree(editables)
    editables.mkdir(parents=True)
    edites = 0
    for nom in EDITABLES:
        source_langue = LOCALES / code / nom
        if source_langue.exists():
            shutil.copyfile(source_langue, editables / nom)
            edites += 1
    faits, total = compter(code)
    return {
        "langue": code,
        "editable": edites == len(EDITABLES),
        "pages_traduites": faits,
        "pages_totales": total,
    }


def publier(code: str) -> dict | None:
    source = BUILD / code
    if not (source / "patcher.lua").exists():
        return None

    destination = SORTIE / code
    if destination.exists():
        shutil.rmtree(destination)
    destination.mkdir(parents=True)

    fichiers = []
    for f in sorted(source.rglob("*")):
        if not f.is_file():
            continue
        relatif = f.relative_to(source).as_posix()
        cible = destination / relatif
        cible.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(f, cible)
        octets = f.read_bytes()
        fichiers.append(
            {
                "chemin": relatif,
                "octets": len(octets),
                "sha256": hashlib.sha256(octets).hexdigest()[:16],
            }
        )

    total = sum(f["octets"] for f in fichiers)
    return {"fichiers": fichiers, "octets": total}


def main() -> None:
    # Toutes les langues du dépôt sont éditables ; seules celles qui ont un mod
    # construit sont installables. Les deux listes ne se recouvrent pas, et
    # confondre les deux priverait un contributeur de toutes les langues vides.
    codes = sys.argv[1:] or sorted(p.name for p in LOCALES.iterdir() if p.is_dir())
    if not codes:
        raise SystemExit("aucune langue dans locales/")

    SORTIE.mkdir(parents=True, exist_ok=True)
    SORTIE_LANGUES.mkdir(parents=True, exist_ok=True)

    langues = []
    for code in codes:
        entree = publier_langue(code)
        mod = publier(code)
        if mod:
            entree.update(mod)
        langues.append(entree)
        etat = (f"{entree['pages_traduites']}/{entree['pages_totales']} pages"
                if entree["pages_totales"] else "vide")
        print(f"  {code:8s} {etat:18s} "
              f"{'mod ' + str(mod['octets'] // 1024) + ' Ko' if mod else 'pas de mod construit'}")

    (SORTIE / "manifeste.json").write_text(
        json.dumps({"langues": langues}, ensure_ascii=False, indent="\t") + "\n",
        encoding="utf-8",
    )
    installables = sum(1 for l in langues if "fichiers" in l)
    print(f"\n{len(langues)} langue(s) éditables, {installables} installable(s)")


if __name__ == "__main__":
    main()
