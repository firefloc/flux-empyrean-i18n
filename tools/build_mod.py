#!/usr/bin/env python3
"""Assemble le mod GDPatch à partir des traductions validées.

Trois sources de texte, trois mécanismes :

- les 167 documents vivent dans `Scripts/texts.gdc`, un autoload de données
  pures : le patcher renvoie une source GDScript entièrement régénérée, ce qui
  évite toute substitution fragile ;
- les chaînes noyées dans les 42 autres scripts sont remplacées une à une par
  substitution de texte ;
- les scènes sont livrées en `.scn` dans `data/`, à l'emplacement visé par leur
  remap.

Usage: build_mod.py [--out <dossier du mod>]
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
DEFAULT_OUT = ROOT / "gdpatch-test" / "GDPatch" / "mods" / "flux_fr"

MANIFEST = """\
id = "flux_fr"

[meta]
name = "Flux Empyrean — traduction française"
version = "{version}"
authors = ["firefloc"]
description = "Traduction française complète. Les réponses d'énigmes restent \
saisissables en anglais."
website = "https://github.com/GDPatch/GDPatch"
"""

PATCHER = """\
-- Genere par tools/build_mod.py — ne pas editer a la main.
local dir = GDPatch.get_mod_directory()

-- Les 167 documents : on renvoie une source GDScript entierement regeneree.
-- `Scripts/texts.gd` est un autoload de donnees pures (aucune methode), donc
-- remplacer la source complete est plus sur que substituer chaine par chaine.
GDPatch.patch_script_as_text("Scripts/texts.gdc", function(ctx, src)
\tlocal f = io.open(dir .. "/texts.gd", "r")
\tif not f then
\t\tprint("texts.gd introuvable, le corpus reste en anglais")
\t\treturn src
\tend
\tlocal fr = f:read("a")
\tf:close()
\treturn fr
end)

-- Les chaines noyees dans le code des autres scripts.
local utils = require("gdpatch.utils")
local strings = dofile(dir .. "/strings.lua")

for path, pairs_ in pairs(strings) do
\tGDPatch.patch_script_as_text(path, function(ctx, src)
\t\tlocal out = src
\t\tlocal applied, missed = 0, 0
\t\tfor _, pair in ipairs(pairs_) do
\t\t\tlocal replaced, n = out:gsub(utils.escape(pair[1]), utils.escape(pair[2], true))
\t\t\tif n > 0 then
\t\t\t\tout = replaced
\t\t\t\tapplied = applied + 1
\t\t\telse
\t\t\t\tmissed = missed + 1
\t\t\t\tprint("NON APPLIQUE " .. ctx.path .. " :: " .. pair[1]:sub(1, 60))
\t\t\tend
\t\tend
\t\tprint(ctx.path .. " : " .. applied .. " remplacements, " .. missed .. " manques")
\t\treturn out
\tend)
end
"""


def lua_string(s: str) -> str:
    escaped = (
        s.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return f'"{escaped}"'


def write_strings_lua(dest: Path, translations: dict) -> int:
    lines = ["-- Genere par tools/build_mod.py", "return {"]
    total = 0
    for path, pairs_ in sorted(translations.items()):
        lines.append(f"\t[{lua_string(path)}] = {{")
        for en, fr in pairs_:
            lines.append(f"\t\t{{{lua_string(en)}, {lua_string(fr)}}},")
            total += 1
        lines.append("\t},")
    lines.append("}")
    dest.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return total


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--version", default="0.1.0")
    args = parser.parse_args()
    out = args.out
    out.mkdir(parents=True, exist_ok=True)

    (out / "gdpatch_mod.toml").write_text(MANIFEST.format(version=args.version), encoding="utf-8")
    (out / "patcher.lua").write_text(PATCHER, encoding="utf-8")

    # --- corpus des documents -------------------------------------------
    merged = WORK / "translation_texts.json"
    if not merged.exists():
        print("work/translation_texts.json absent : lance d'abord merge_translations.py")
        return 1
    subprocess.run(
        [
            sys.executable,
            str(ROOT / "tools" / "gen_texts_gd.py"),
            str(WORK / "texts_corpus.json"),
            str(out / "texts.gd"),
            str(merged),
        ],
        check=True,
    )

    # --- chaines des autres scripts --------------------------------------
    scripts_file = WORK / "translation_scripts.json"
    scripts = json.loads(scripts_file.read_text(encoding="utf-8")) if scripts_file.exists() else {}
    n = write_strings_lua(out / "strings.lua", scripts)
    print(f"strings.lua : {n} remplacements sur {len(scripts)} script(s)")

    print(f"\nmod assemble dans {out}")
    print("scenes traduites : a generer avec tools/godot/patch_scenes.gd vers", out / "data")
    return 0


if __name__ == "__main__":
    sys.exit(main())
