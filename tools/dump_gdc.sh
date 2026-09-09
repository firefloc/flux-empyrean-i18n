#!/usr/bin/env bash
# Decompresse les scripts .gdc extraits (header GDSC de 12 octets + zstd)
# pour lire leur pool de constantes en clair.
# Usage: dump_gdc.sh <dossier_extract> <dossier_sortie>
set -euo pipefail
src="$1"; dst="$2"
mkdir -p "$dst"
n=0
while IFS= read -r -d '' f; do
	name="${f#"$src"/}"
	out="$dst/${name//\//__}"
	out="${out%.gdc}.bin"
	if tail -c +13 "$f" | zstd -dq -o "$out" 2>/dev/null; then
		n=$((n + 1))
	fi
done < <(find "$src" -name '*.gdc' -print0)
echo "decompresses: $n scripts -> $dst"
