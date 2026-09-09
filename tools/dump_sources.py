#!/usr/bin/env python3
"""Décompile les scripts du jeu vers `work/src`.

    python3 tools/dump_sources.py <dossier du jeu>

Les scripts sont compilés en jetons binaires ; seul GDPatch sait les rendre en
texte. On installe donc un mod temporaire qui les écrit sur disque, on lance le
jeu quelques secondes, et on le retire.

Sans cette étape, tout le relevé des faits du jeu — verrous d'énigme, chaînes
noyées dans le code — travaillerait sur des sources périmées, voire absentes
après un simple clone.

Deux précautions qui ont chacune coûté un incident :

- **Les patchers de GDPatch se composent.** Si un mod de traduction est actif,
  il aura déjà réécrit la source quand notre relevé la reçoit, et on
  décompilerait du français. On écarte donc tous les autres mods le temps du
  relevé, et on les remet en place quoi qu'il arrive.
- **Sous Windows le chargeur doit s'appeler `winmm.dll`.** S'il est déjà là sous
  ce nom, on n'y touche pas. Sinon on le renomme le temps du relevé et on
  restaure l'état d'origine : le dossier du joueur ne doit pas garder de trace
  de notre passage.
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jeu as J  # noqa: E402

RACINE = Path(__file__).resolve().parent.parent
SORTIE = RACINE / "work" / "src"

PATCHER = '''\
local pack = GDPatch.get_pack()
local scripts = {{}}
for _, f in ipairs(pack.files) do
\tif f:sub(-4) == ".gdc" then table.insert(scripts, f) end
end
print("DUMP " .. #scripts .. " scripts")
GDPatch.patch_script_as_text(scripts, function(ctx, src)
\tlocal nom = ctx.path:gsub("/", "__"):gsub("%.gdc$", ".gd")
\tlocal out = io.open("{sortie}/" .. nom, "w")
\tif out then out:write(src); out:close() end
\treturn src
end)
'''


class ModsEcartes:
    """Écarte les autres mods, et les remet quoi qu'il arrive.

    Un relevé qui laisserait les mods du joueur dans un dossier de côté serait
    pire que pas de relevé du tout : son jeu ne serait plus traduit et il ne
    saurait pas pourquoi.
    """

    def __init__(self, dossier_mods: Path):
        self.mods = dossier_mods
        self.ecartes = dossier_mods.parent / "_mods_ecartes"
        self.deplaces: list[str] = []

    def __enter__(self):
        self.mods.mkdir(parents=True, exist_ok=True)
        self.ecartes.mkdir(exist_ok=True)
        for mod in self.mods.iterdir():
            if mod.is_dir() and mod.name != "_dump_sources":
                shutil.move(str(mod), str(self.ecartes / mod.name))
                self.deplaces.append(mod.name)
        return self

    def __exit__(self, *_):
        for nom in self.deplaces:
            source = self.ecartes / nom
            if source.exists():
                shutil.move(str(source), str(self.mods / nom))
        shutil.rmtree(self.mods / "_dump_sources", ignore_errors=True)
        if self.ecartes.exists() and not any(self.ecartes.iterdir()):
            self.ecartes.rmdir()


class ChargeurWindows:
    """Donne au chargeur le nom sous lequel Windows le charge, puis le rend.

    GDPatch se fait passer pour `winmm.dll`. Posé sous son nom d'origine, il ne
    s'exécute jamais — sans erreur, sans message. Si le joueur a déjà fait le
    renommage, on ne touche à rien.
    """

    def __init__(self, dossier: Path, actif: bool):
        self.dossier = dossier
        self.actif = actif
        self.renomme = False

    def __enter__(self):
        if not self.actif:
            return self
        attendu = self.dossier / "winmm.dll"
        publie = self.dossier / "gdpatch_loader.dll"
        if not attendu.exists() and publie.exists():
            publie.rename(attendu)
            self.renomme = True
        return self

    def __exit__(self, *_):
        if self.renomme:
            (self.dossier / "winmm.dll").rename(self.dossier / "gdpatch_loader.dll")


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    dossier = Path(sys.argv[1]).expanduser().resolve()
    if not dossier.is_dir():
        raise SystemExit(f"dossier introuvable : {dossier}")

    executable = J.trouver_executable(dossier)
    if executable is None:
        raise SystemExit(f"exécutable introuvable dans {dossier}")

    SORTIE.mkdir(parents=True, exist_ok=True)
    for ancien in SORTIE.glob("*.gd"):
        ancien.unlink()

    mods = dossier / "GDPatch" / "mods"
    windows = J.plateforme_du_jeu(executable) == "Windows"

    with ModsEcartes(mods), ChargeurWindows(dossier, windows):
        mod = mods / "_dump_sources"
        mod.mkdir(parents=True, exist_ok=True)
        (mod / "gdpatch_mod.toml").write_text('id = "_dump_sources"\n', encoding="utf-8")
        # Lua veut des slashes avant, y compris sous Windows — et un antislash
        # dans une chaîne Lua ouvrirait un échappement.
        (mod / "patcher.lua").write_text(
            PATCHER.format(sortie=SORTIE.as_posix()), encoding="utf-8"
        )
        sortie = J.lancer_le_jeu(dossier, executable)

    for ligne in sortie.splitlines():
        if "DUMP" in ligne:
            print(ligne.split("DUMP", 1)[1].strip().join(("DUMP ", "")))
            break

    fichiers = list(SORTIE.glob("*.gd"))
    print(f"sources décompilées : {len(fichiers)} fichiers")
    if not fichiers:
        raise SystemExit(
            "aucune source décompilée — le chargeur GDPatch n'a probablement pas été\n"
            "injecté. Sous Windows, il doit s'appeler winmm.dll et se trouver à côté\n"
            "de l'exécutable ; sous Proton il faut en plus l'option de lancement\n"
            '  WINEDLLOVERRIDES="winmm=n,b" %command%'
        )


if __name__ == "__main__":
    main()
