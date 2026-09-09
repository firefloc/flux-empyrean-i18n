#!/usr/bin/env python3
"""Contrôle d'intégration en jeu : ce que le mod sert réellement.

    python3 tools/check_ingame.py <dossier du jeu> [langue]

Régénère le corpus depuis les traductions fusionnées, l'installe dans le mod,
lance le jeu quelques centaines d'images et lit ce que l'autoload `Texts` rend.
Répond à deux questions qu'aucun contrôle en mémoire ne peut trancher : combien
de documents sont effectivement passés dans la langue cible, et les blocs
chiffrés sont-ils intacts.

Le contrôle lui-même est **généré** depuis `frozen_segments.json` : l'écrire à
la main revenait à maintenir deux listes de segments gelés, et l'une des deux a
fini par en oublier un.
"""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RACINE / "tools"))
import jeu as J  # noqa: E402

WORK = RACINE / "work"


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    dossier = Path(sys.argv[1]).expanduser().resolve()
    langue = sys.argv[2] if len(sys.argv) > 2 else os.environ.get("LOCALE", "fr")
    mod = dossier / "GDPatch" / "mods" / f"flux_{langue}"
    if not (mod / "patcher.lua").is_file():
        raise SystemExit(f"aucun mod installé dans {mod}")

    executable = J.trouver_executable(dossier)
    if executable is None:
        raise SystemExit(f"exécutable introuvable dans {dossier}")

    outils = RACINE / "tools"
    for commande in (
        [J.python(), str(outils / "gen_texts_gd.py"), str(WORK / "texts_corpus.json"),
         str(mod / "texts.gd"), str(WORK / "translation_texts.json")],
        [J.python(), str(outils / "gen_scenes_gd.py"),
         str(WORK / "translation_scenes.json"), str(mod / "texts.gd")],
        [J.python(), str(outils / "gen_ingame_check.py"),
         str(outils / "ingame" / "bilan_integration.gd")],
    ):
        resultat = subprocess.run(commande, capture_output=True, text=True,
                                  env={**os.environ, "LOCALE": langue})
        if resultat.returncode != 0:
            sys.stderr.write(resultat.stdout + resultat.stderr)
            raise SystemExit(f"{Path(commande[1]).name} a échoué")

    sortie = J.lancer_le_jeu(dossier, executable, images=250)
    interessant = ("BILAN", "CORPUS", "SCENES", "MANQUE", "NON APPLIQUE", "Parse Error")
    vu = False
    for ligne in sortie.splitlines():
        if any(marqueur in ligne for marqueur in interessant):
            print("  " + ligne.split("lua: ")[-1].split(" mod_id")[0].strip())
            vu = True
    if not vu:
        raise SystemExit(
            "le mod n'a rien dit — le chargeur GDPatch n'a probablement pas été injecté"
        )


if __name__ == "__main__":
    main()
