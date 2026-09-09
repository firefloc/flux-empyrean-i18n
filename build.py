#!/usr/bin/env python3
"""Construit le mod de traduction pour une langue donnée.

    python3 build.py <exécutable du jeu> [langue]

La langue par défaut est `fr`. Tout ce qui est propre à une langue vit dans
`locales/<langue>/` ; le reste — extraction, inventaire des verrous, détection
des segments gelés, contrôles — est identique pour toutes.

Le mod atterrit dans `build/<langue>/`. Rien n'est copié dans le jeu : c'est
`install.py` qui s'en charge, séparément et volontairement.

Écrit en Python plutôt qu'en shell pour une raison simple : quelqu'un qui
bifurque le projet sous Windows doit pouvoir construire. Les six scripts shell
qu'il remplace ne s'exécutaient nulle part ailleurs que sur Linux et macOS, et
deux d'entre eux injectaient GDPatch par `LD_PRELOAD`, qui n'existe pas sous
Windows.

Prérequis : Python 3, Godot 4.7, et le chargeur GDPatch posé dans le dossier du
jeu — l'étape de décompilation lance réellement le jeu.
"""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent
sys.path.insert(0, str(RACINE / "tools"))
import jeu as J  # noqa: E402

OUTILS = RACINE / "tools"
WORK = RACINE / "work"


def etape(numero: int, titre: str) -> None:
    print(f"== {numero}/6 {titre}")


def py(script: str, *arguments: str, silencieux: bool = False,
       env: dict[str, str] | None = None) -> str:
    """Un outil Python du projet, avec la même interprète que nous."""
    resultat = subprocess.run(
        [J.python(), str(OUTILS / script), *arguments],
        env={**os.environ, **(env or {})},
        capture_output=True, text=True,
    )
    if resultat.returncode != 0:
        sys.stderr.write(resultat.stdout + resultat.stderr)
        raise SystemExit(f"{script} a échoué")
    if not silencieux and resultat.stdout.strip():
        print(resultat.stdout.rstrip())
    return resultat.stdout


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    executable = Path(sys.argv[1]).expanduser().resolve()
    langue = sys.argv[2] if len(sys.argv) > 2 else os.environ.get("LOCALE", "fr")
    if not executable.is_file():
        raise SystemExit(f"introuvable : {executable}")
    dossier_langue = RACINE / "locales" / langue
    if not dossier_langue.is_dir():
        raise SystemExit(
            f"langue inconnue : {dossier_langue}\n"
            f"Crée-la : python3 tools/init_locale.py {langue}"
        )

    sortie = RACINE / "build" / langue
    sortie.mkdir(parents=True, exist_ok=True)
    WORK.mkdir(exist_ok=True)
    env = {"LOCALE": langue, "WORK": str(WORK)}

    etape(1, "extraction du pack")
    resultat = J.lancer_godot(
        OUTILS / "godot", "extract.gd",
        env={"GAME_EXE": str(executable), "OUT_DIR": str(WORK)},
    )
    if resultat.returncode != 0:
        sys.stderr.write(resultat.stdout + resultat.stderr)
        raise SystemExit("extraction du pack impossible")

    etape(2, "décompilation des scripts et relevé des faits du jeu")
    py("dump_sources.py", str(executable.parent))
    py("dump_script_strings.py", env=env)
    for script in ("dump_texts.gd",):
        J.lancer_godot(OUTILS / "inspect", script,
                       env={"GAME_EXE": str(executable), "OUT_DIR": str(WORK)})
    for script in ("dump_text.gd", "dump_ui.gd"):
        J.lancer_godot(OUTILS / "godot", script,
                       env={"GAME_EXE": str(executable), "OUT_DIR": str(WORK)})
    py("merge_scene_sources.py", env=env)
    py("build_locks.py", silencieux=True, env=env)
    py("build_frozen.py", silencieux=True, env=env)
    py("crack_vigenere.py", env=env)
    acrostiches = py("check_acrostics.py", silencieux=True, env=env)
    for ligne in acrostiches.splitlines():
        if "PORTE UNE" in ligne:
            print(f"  acrostiche porteur : {ligne.strip()}")
    # La carte que l'éditeur web charge : des nombres de pages et des empreintes,
    # jamais de texte du jeu. Elle suit la version du jeu, donc on la régénère.
    py("build_index_web.py", env=env)

    etape(3, "contrôle de la traduction")
    controle = subprocess.run(
        [J.python(), str(OUTILS / "verify_locale.py")],
        env={**os.environ, **env}, capture_output=True, text=True,
    )
    print(controle.stdout.rstrip() or controle.stderr.rstrip())
    if controle.returncode != 0:
        sys.stderr.write(controle.stderr)
        raise SystemExit("traduction refusée : corrige les erreurs ci-dessus")

    etape(4, "génération des patchs")
    py("locale_to_work.py", env=env)
    py("gen_texts_gd.py", str(WORK / "texts_corpus.json"), str(sortie / "texts.gd"),
       str(WORK / "translation_texts.json"), env=env)
    py("gen_strings_lua.py", str(sortie / "strings.lua"), env=env)
    py("build_answer_patch.py", silencieux=True, env=env)
    py("build_decrypt_patch.py", silencieux=True, env=env)
    py("gen_answers_lua.py", str(sortie / "answers.lua"), env=env)

    etape(5, "traduction des scènes")
    # Le mod ne livre aucune scène : il fait fabriquer au jeu, à son premier
    # lancement, les `.scn` traduits depuis sa propre copie. Voir le README — la
    # mutation en mémoire seule ne rendait que 65 chaînes sur 205, l'écriture
    # sur disque en rend 180, comme la réécriture hors ligne qu'elle remplace.
    remap = py("remap_scenes.py", str(WORK / "strings_scenes.json"),
               silencieux=True, env=env)
    if remap.strip():
        print("  " + remap.strip().splitlines()[-1])
    py("gen_scenes_gd.py", str(WORK / "translation_scenes.json"),
       str(sortie / "texts.gd"), env=env)

    etape(6, "assemblage")
    (sortie / "patcher.lua").write_text(
        (RACINE / "mod" / "patcher.lua").read_text(encoding="utf-8"), encoding="utf-8"
    )
    (sortie / "gdpatch_mod.toml").write_text(
        (RACINE / "mod" / "gdpatch_mod.toml").read_text(encoding="utf-8")
        .replace("{{LANGUE}}", langue),
        encoding="utf-8",
    )

    poids = sum(f.stat().st_size for f in sortie.rglob("*") if f.is_file())
    print(f"\nmod prêt : {sortie}  ({poids // 1024} Ko, "
          f"{sum(1 for f in sortie.rglob('*') if f.is_file())} fichiers)")


if __name__ == "__main__":
    main()
