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


def publier(code: str) -> dict | None:
    source = BUILD / code
    if not (source / "patcher.lua").exists():
        print(f"  {code} : aucun mod construit — lance d'abord ./build.sh", file=sys.stderr)
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
    print(f"  {code} : {len(fichiers)} fichiers, {total // 1024} Ko")
    return {"langue": code, "fichiers": fichiers, "octets": total}


def main() -> None:
    codes = sys.argv[1:] or sorted(
        p.name for p in BUILD.iterdir() if p.is_dir() and (p / "patcher.lua").exists()
    )
    if not codes:
        raise SystemExit("aucun mod construit dans build/")

    SORTIE.mkdir(parents=True, exist_ok=True)
    langues = [r for code in codes if (r := publier(code))]
    (SORTIE / "manifeste.json").write_text(
        json.dumps({"langues": langues}, ensure_ascii=False, indent="\t") + "\n",
        encoding="utf-8",
    )
    print(f"manifeste : {len(langues)} langue(s) installables depuis la page")


if __name__ == "__main__":
    main()
