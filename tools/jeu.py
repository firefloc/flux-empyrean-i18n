#!/usr/bin/env python3
"""Ce qu'il faut savoir du jeu et de la plateforme, en un seul endroit.

Tout l'outillage a besoin des mêmes réponses : où est l'exécutable, comment on y
injecte GDPatch, où trouver Godot. Ces réponses diffèrent d'un système à l'autre
et se trompaient jusqu'ici en silence — on les rassemble donc ici, une fois.

Les deux mécanismes d'injection n'ont rien en commun :

    Linux   `LD_PRELOAD` pointe la bibliothèque, le noyau la charge avant tout.
    Windows le chargeur doit s'appeler `winmm.dll` et se trouver à côté de
            l'exécutable — c'est le nom sous lequel le jeu le réclame. Posé sous
            son nom d'origine, il ne s'exécute jamais et ne dit rien.

C'est ce détail qui a fait perdre un cycle entier de débogage : le mod se
chargeait, et pourtant rien ne se traduisait.
"""

from __future__ import annotations

import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

CHARGEURS = {
    "Linux": "libgdpatch_loader.so",
    "Windows": "winmm.dll",
    "Darwin": "libgdpatch_loader.dylib",
}

# Le nom sous lequel GDPatch publie ses chargeurs. Sous Windows il faut le
# renommer ; ailleurs il se pose tel quel.
NOMS_PUBLIES = {
    "Linux": "libgdpatch_loader.so",
    "Windows": "gdpatch_loader.dll",
    "Darwin": "libgdpatch_loader.dylib",
}

RELEASES_GDPATCH = "https://github.com/GDPatch/GDPatch/releases/latest"


def systeme() -> str:
    return platform.system()


def trouver_executable(dossier: Path) -> Path | None:
    """L'exécutable du jeu dans un dossier d'installation.

    Le binaire livré par Steam décide de tout — y compris sous Proton, où c'est
    le `.exe` qui tourne et donc la DLL qu'il faut. Le système de l'utilisateur
    n'entre pas en ligne de compte.
    """
    for motif in ("flux-empyrean.exe", "flux-empyrean.x86_64", "Flux Empyrean.exe",
                  "flux-empyrean*"):
        for candidat in sorted(dossier.glob(motif)):
            if candidat.is_file():
                return candidat
    return None


def plateforme_du_jeu(executable: Path) -> str:
    """La plateforme visée par ce binaire, pas celle de la machine."""
    if executable.suffix.lower() == ".exe":
        return "Windows"
    if executable.suffix == ".x86_64":
        return "Linux"
    return systeme()


def chargeur_installe(dossier: Path) -> Path | None:
    """Le chargeur GDPatch déjà posé, sous n'importe lequel de ses noms."""
    for nom in {*CHARGEURS.values(), *NOMS_PUBLIES.values()}:
        candidat = dossier / nom
        if candidat.is_file():
            return candidat
    return None


def godot() -> str:
    """La commande Godot, que son nom change beaucoup d'un système à l'autre.

    Sous Windows elle s'appelle typiquement `Godot_v4.7-stable_win64.exe` et
    n'est presque jamais dans le PATH. La variable `GODOT` permet de la
    désigner, et le message d'erreur le dit plutôt que d'échouer sur un
    « commande introuvable » qui n'aide personne.
    """
    demandee = os.environ.get("GODOT")
    if demandee:
        return demandee
    for nom in ("godot", "godot4", "Godot", "godot.exe", "Godot_v4.7-stable_win64.exe"):
        trouve = shutil.which(nom)
        if trouve:
            return trouve
    raise SystemExit(
        "Godot est introuvable. Installe Godot 4.7 et mets-le dans le PATH, ou\n"
        "désigne-le : GODOT=/chemin/vers/godot  (Windows : set GODOT=C:\\...\\Godot.exe)"
    )


def lancer_godot(projet: Path, script: str, env: dict[str, str] | None = None,
                 silencieux: bool = True) -> subprocess.CompletedProcess:
    """Un script Godot en mode sans écran, dans un projet donné."""
    commande = [godot(), "--headless", "--path", str(projet), "-s", script]
    return subprocess.run(
        commande,
        env={**os.environ, **(env or {})},
        capture_output=silencieux,
        text=True,
    )


def lancer_le_jeu(dossier: Path, executable: Path, secondes: int = 180,
                  images: int = 200) -> str:
    """Lance le jeu avec GDPatch, le temps qu'il fasse son travail.

    Rend la sortie mêlée, parce que GDPatch écrit sur les deux flux et qu'on
    veut tout lire. Le jeu s'arrête de lui-même après `images` images ; le délai
    n'est qu'un filet contre un blocage.
    """
    chargeur = chargeur_installe(dossier)
    if chargeur is None:
        raise SystemExit(
            f"Le chargeur GDPatch est absent de {dossier}.\n"
            f"Récupère-le sur {RELEASES_GDPATCH} :\n"
            "  Linux   : libgdpatch_loader.so\n"
            "  Windows : gdpatch_loader.dll, à renommer en winmm.dll\n"
            "  macOS   : libgdpatch_loader.dylib"
        )

    env = dict(os.environ)
    if plateforme_du_jeu(executable) != "Windows":
        # Sous Linux le chargeur s'injecte à l'exécution. Le chemin d'un dossier
        # Steam contient une espace — « common/Flux Empyrean » — et LD_PRELOAD
        # découpe dessus : le chemin absolu y devenait deux entrées, toutes deux
        # introuvables, et ld.so se contentait de le dire sur stderr avant de
        # lancer le jeu sans mod. On ne met donc dans LD_PRELOAD qu'un nom de
        # fichier nu, et le dossier dans LD_LIBRARY_PATH, séparé par des
        # deux-points où l'espace ne gêne pas. C'est ce que fait le lanceur
        # officiel, et ce que cette fonction ne faisait pas.
        env["LD_PRELOAD"] = os.pathsep.join(
            [chargeur.name, env.get("LD_PRELOAD", "")]
        ).strip(os.pathsep)
        env["LD_LIBRARY_PATH"] = os.pathsep.join(
            [str(dossier), env.get("LD_LIBRARY_PATH", "")]
        ).strip(os.pathsep)

    try:
        sortie = subprocess.run(
            [str(executable), "--quit-after", str(images)],
            cwd=dossier, env=env, capture_output=True, text=True,
            timeout=secondes, errors="replace",
        )
    except subprocess.TimeoutExpired as expiration:
        return (expiration.stdout or b"").decode("utf-8", "replace") + \
               (expiration.stderr or b"").decode("utf-8", "replace")
    return (sortie.stdout or "") + (sortie.stderr or "")


def python() -> str:
    """L'interpréteur courant, pour que les sous-commandes restent cohérentes."""
    return sys.executable
