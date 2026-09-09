#!/usr/bin/env bash
# Chaine complete : extract -> (tes edits) -> repack -> splice.
# Usage: build.sh extract|repack <chemin_exe_du_jeu>
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
work="${WORK:-$root/work}"
mkdir -p "$work"

cmd="${1:?extract ou repack}"
exe="${2:?chemin de l exe du jeu}"

case "$cmd" in
extract)
	GAME_EXE="$exe" OUT_DIR="$work" godot --headless --path "$here/godot" -s "$here/godot/extract.gd"
	;;
repack)
	OUT_DIR="$work" godot --headless --path "$here/godot" -s "$here/godot/repack.gd"
	python3 "$here/splice.py" "$exe" "$work/repack.pck" "$work/$(basename "$exe")"
	;;
*)
	echo "commande inconnue: $cmd" >&2
	exit 1
	;;
esac
