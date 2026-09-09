#!/usr/bin/env python3
"""Installe un mod construit, ou une release téléchargée, dans le dossier du jeu.

    python3 install.py <dossier du jeu> [langue]
    python3 install.py --depuis <dossier du mod> <dossier du jeu> [langue]
    python3 install.py --desinstaller <dossier du jeu>

Sans `--depuis`, on installe ce que `build.py` a produit. Avec, on installe un
dossier quelconque — typiquement une release décompressée, pour quelqu'un qui
n'a ni Godot ni Python… sauf qu'il lui faut Python pour lancer ceci. La page web
fait la même chose sans rien installer du tout, et c'est le chemin recommandé.

Rien du jeu n'est modifié : on ajoute deux entrées, et on les retire avec
`--desinstaller`. Une vérification d'intégrité Steam n'y touche pas non plus —
ce sont des fichiers que Steam ne connaît pas.
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent
sys.path.insert(0, str(RACINE / "tools"))
import jeu as J  # noqa: E402

A_RETIRER = ("GDPatch", "libgdpatch_loader.so", "gdpatch_loader.dll", "winmm.dll",
             "libgdpatch_loader.dylib", "run_with_gdpatch.sh")


def desinstaller(dossier: Path) -> None:
    retires = []
    for nom in A_RETIRER:
        cible = dossier / nom
        if cible.is_dir():
            shutil.rmtree(cible)
            retires.append(nom)
        elif cible.exists():
            cible.unlink()
            retires.append(nom)
    print("désinstallé : " + (", ".join(retires) if retires else "rien à retirer"))
    print("Retire aussi la ligne des options de lancement Steam.")


def installer(mod: Path, dossier: Path, langue: str) -> None:
    if not mod.is_dir():
        raise SystemExit(
            f"dossier introuvable : {mod}\n"
            f"Construis-le : python3 build.py <exécutable> {langue}\n"
            f"ou installe une release : python3 install.py --depuis <dossier> "
            f'"{dossier}" {langue}'
        )
    # Un mod vaut par son patcher : sans lui, on copierait n'importe quoi.
    if not (mod / "patcher.lua").is_file():
        raise SystemExit(f"« {mod} » ne ressemble pas à un mod : patcher.lua manquant")

    executable = J.trouver_executable(dossier)
    if executable is None:
        raise SystemExit(
            f"aucun exécutable de Flux Empyrean dans {dossier}.\n"
            "Choisis le dossier qui contient flux-empyrean.x86_64 ou "
            "Flux Empyrean.exe."
        )
    plateforme = J.plateforme_du_jeu(executable)

    # Sous Windows — Proton compris — GDPatch se charge en se faisant passer
    # pour winmm.dll. Posé sous son nom d'origine, il ne s'exécute jamais et ne
    # dit rien : c'est le genre de silence qui coûte une soirée.
    attendu = J.CHARGEURS[plateforme]
    publie = dossier / J.NOMS_PUBLIES[plateforme]
    if not (dossier / attendu).exists() and publie.exists() and publie.name != attendu:
        publie.rename(dossier / attendu)
        print(f"chargeur renommé en {attendu} — c'est sous ce nom qu'il est chargé")

    if not (dossier / attendu).exists():
        raise SystemExit(
            f"Le chargeur GDPatch est absent de {dossier}.\n"
            f"Récupère-le sur {J.RELEASES_GDPATCH} :\n"
            f"  ce jeu est un binaire {plateforme}, il lui faut "
            f"{J.NOMS_PUBLIES[plateforme]}"
            + (" — à renommer en winmm.dll, ce script le fait"
               if plateforme == "Windows" else "")
        )

    destination = dossier / "GDPatch" / "mods" / f"flux_{langue}"
    if destination.exists():
        shutil.rmtree(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(mod, destination)

    poids = sum(f.stat().st_size for f in destination.rglob("*") if f.is_file())
    print(f"installé : {destination}  ({poids // 1024} Ko)")
    print()
    print("Au premier lancement, le mod fabrique les scènes traduites depuis ta")
    print("propre copie du jeu — quelques secondes, une seule fois. L'interface passe")
    print("dans ta langue au lancement suivant, et les scènes se refont toutes seules")
    print("quand le jeu se met à jour.")
    print()
    if plateforme == "Windows":
        print("Options de lancement Steam, si tu joues sous Proton ou Wine :")
        print('  WINEDLLOVERRIDES="winmm=n,b" %command%')
        print("Sous Windows véritable, il n'y a rien à faire.")
    else:
        print("Options de lancement Steam :")
        print("  ./run_with_gdpatch.sh %command%")
        print()
        print("Récupère aussi run_with_gdpatch.sh sur gdpatch.dev et pose-le dans le")
        print("dossier du jeu : le chemin d'installation Steam contient une espace, et")
        print("LD_PRELOAD découpe dessus.")


def main() -> None:
    arguments = sys.argv[1:]
    if not arguments:
        raise SystemExit(__doc__)

    if arguments[0] == "--desinstaller":
        if len(arguments) < 2:
            raise SystemExit(__doc__)
        dossier = Path(arguments[1]).expanduser().resolve()
        if not dossier.is_dir():
            raise SystemExit(f"dossier introuvable : {dossier}")
        return desinstaller(dossier)

    source = None
    if arguments[0] == "--depuis":
        if len(arguments) < 3:
            raise SystemExit(__doc__)
        source = Path(arguments[1]).expanduser().resolve()
        arguments = arguments[2:]

    dossier = Path(arguments[0]).expanduser().resolve()
    langue = arguments[1] if len(arguments) > 1 else "fr"
    if not dossier.is_dir():
        raise SystemExit(f"dossier introuvable : {dossier}")
    installer(source or (RACINE / "build" / langue), dossier, langue)


if __name__ == "__main__":
    main()
