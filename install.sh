#!/usr/bin/env bash
# Installe un mod construit dans le dossier du jeu.
#
#   ./install.sh <dossier du jeu> [langue]
#   ./install.sh --depuis <dossier du mod> <dossier du jeu> [langue]
#
# Sans `--depuis`, on installe le mod construit localement par `./build.sh`.
# Avec, on installe un dossier quelconque — typiquement une release
# décompressée, pour un joueur qui n'a ni Godot ni Python.
#
# Rien n'est modifié dans le jeu : on ajoute trois entrées, et on les retire
# avec `--desinstaller`. Une vérification d'intégrité Steam ne les touche pas
# non plus — ce sont des fichiers que Steam ne connaît pas.
set -euo pipefail

ici="$(cd "$(dirname "$0")" && pwd)"
source_explicite=""
if [ "${1:-}" = "--depuis" ]; then
	source_explicite="${2:?usage: install.sh --depuis <dossier du mod> <dossier du jeu> [langue]}"
	shift 2
fi
jeu="${1:?usage: install.sh [--depuis <dossier du mod>] <dossier du jeu> [langue]}"
langue="${2:-fr}"

if [ "${1:-}" = "--desinstaller" ]; then
	jeu="${2:?usage: install.sh --desinstaller <dossier du jeu>}"
	rm -rf "$jeu/GDPatch" "$jeu/libgdpatch_loader.so" "$jeu/gdpatch_loader.dll" \
		"$jeu/libgdpatch_loader.dylib" "$jeu/run_with_gdpatch.sh"
	echo "désinstallé. Retire aussi « ./run_with_gdpatch.sh %command% » des options de lancement Steam."
	exit 0
fi

[ -d "$jeu" ] || { echo "dossier introuvable : $jeu" >&2; exit 1; }
mod="${source_explicite:-$ici/build/$langue}"
if [ ! -d "$mod" ]; then
	if [ -n "$source_explicite" ]; then
		echo "dossier introuvable : $mod" >&2
	else
		echo "aucun mod construit pour « $langue »." >&2
		echo "Construis-le avec ./build.sh, ou installe une release :" >&2
		echo "  ./install.sh --depuis <dossier décompressé> \"$jeu\" $langue" >&2
	fi
	exit 1
fi
# Un mod vaut par son patcher : sans lui, on copierait n'importe quel dossier.
[ -f "$mod/patcher.lua" ] || { echo "« $mod » ne ressemble pas à un mod : patcher.lua manquant" >&2; exit 1; }

# GDPatch : le chargeur, à récupérer une fois. Un seul des trois suffit — celui
# de la plateforme du joueur.
charge=""
for c in libgdpatch_loader.so gdpatch_loader.dll libgdpatch_loader.dylib; do
	[ -f "$jeu/$c" ] && charge="$c"
done
if [ -z "$charge" ]; then
	echo "Le chargeur GDPatch est absent du dossier du jeu."
	echo "Récupère-le pour ta plateforme : https://github.com/GDPatch/GDPatch/releases/latest"
	echo "  Linux   : libgdpatch_loader.so"
	echo "  Windows : gdpatch_loader.dll"
	echo "  macOS   : libgdpatch_loader.dylib"
	exit 1
fi

destination="$jeu/GDPatch/mods/flux_$langue"
mkdir -p "$destination"
rm -rf "$destination"
cp -r "$mod" "$destination"

echo "installé : $destination  ($(du -sh "$destination" | cut -f1))"
echo
echo "Au premier lancement, le mod fabrique les scènes traduites depuis ta propre"
echo "copie du jeu — quelques secondes, une seule fois. L'interface passe en français"
echo "au lancement suivant. Elles se refont toutes seules quand le jeu se met à jour."
echo
echo "Il reste à mettre ceci dans les options de lancement Steam du jeu :"
echo "  Linux / macOS : ./run_with_gdpatch.sh %command%"
echo "  Windows       : rien à faire, le chargeur se branche seul"
echo
echo "Sur Linux et macOS, télécharge aussi run_with_gdpatch.sh depuis gdpatch.dev"
echo "et place-le dans le dossier du jeu. Il est nécessaire parce que le chemin"
echo "d'installation Steam contient une espace, et LD_PRELOAD découpe dessus."
