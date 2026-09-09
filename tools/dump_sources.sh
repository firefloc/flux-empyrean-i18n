#!/usr/bin/env bash
# Décompile les scripts du jeu vers work/src.
#
#   ./tools/dump_sources.sh <dossier du jeu>
#
# Les scripts sont compilés en tokens binaires : c'est GDPatch qui sait les
# rendre en texte. On installe donc un mod temporaire qui les écrit sur disque,
# on lance le jeu quelques secondes, et on le retire.
#
# Sans cette étape, tout le relevé des faits du jeu — verrous d'énigme, chaînes
# noyées dans le code — travaillerait sur des sources périmées, voire absentes
# après un simple clone.
set -euo pipefail

ici="$(cd "$(dirname "$0")" && pwd)"
racine="$(dirname "$ici")"
jeu="${1:?usage: dump_sources.sh <dossier du jeu>}"
sortie="$racine/work/src"

exe="$(find "$jeu" -maxdepth 1 -name 'flux-empyrean*' -type f | head -1)"
[ -n "$exe" ] || { echo "exécutable introuvable dans $jeu" >&2; exit 1; }

charge=""
for c in libgdpatch_loader.so gdpatch_loader.dll libgdpatch_loader.dylib; do
	[ -f "$jeu/$c" ] && charge="$c"
done
[ -n "$charge" ] || {
	echo "Le chargeur GDPatch est absent de $jeu." >&2
	echo "Récupère-le sur https://github.com/GDPatch/GDPatch/releases/latest" >&2
	exit 1
}

# Les patchers de GDPatch se composent : si un mod de traduction est actif, il
# aura déjà réécrit la source quand notre relevé la reçoit, et on décompilerait
# du français. On écarte donc tous les autres mods le temps du relevé.
ecartes="$jeu/GDPatch/_mods_ecartes"
restaurer() {
	if [ -d "$ecartes" ]; then
		mv "$ecartes"/* "$jeu/GDPatch/mods/" 2>/dev/null || true
		rmdir "$ecartes" 2>/dev/null || true
	fi
	rm -rf "$jeu/GDPatch/mods/_dump_sources"
}
trap restaurer EXIT

mkdir -p "$ecartes" "$jeu/GDPatch/mods"
for m in "$jeu/GDPatch/mods"/*; do
	[ -d "$m" ] && [ "$(basename "$m")" != "_dump_sources" ] && mv "$m" "$ecartes/"
done

mod="$jeu/GDPatch/mods/_dump_sources"
mkdir -p "$mod" "$sortie"

printf 'id = "_dump_sources"\n' > "$mod/gdpatch_mod.toml"
cat > "$mod/patcher.lua" <<LUA
local pack = GDPatch.get_pack()
local scripts = {}
for _, f in ipairs(pack.files) do
	if f:sub(-4) == ".gdc" then table.insert(scripts, f) end
end
print("DUMP " .. #scripts .. " scripts")
GDPatch.patch_script_as_text(scripts, function(ctx, src)
	local nom = ctx.path:gsub("/", "__"):gsub("%.gdc\$", ".gd")
	local out = io.open("$sortie/" .. nom, "w")
	if out then out:write(src); out:close() end
	return src
end)
LUA

cd "$jeu"
timeout 180 env LD_LIBRARY_PATH="$PWD:${LD_LIBRARY_PATH:-}" LD_PRELOAD="$charge" \
	"$exe" --quit-after 200 2>&1 | grep -a "DUMP" || true
echo "sources décompilées : $(find "$sortie" -name '*.gd' | wc -l) fichiers"
