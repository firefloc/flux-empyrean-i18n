#!/usr/bin/env bash
# Contrôle d'intégration en jeu, à lancer après chaque fusion de lots.
#
# Régénère texts.gd depuis les traductions fusionnées, l'installe dans le mod
# GDPatch, lance le jeu quelques centaines d'images et lit le corpus depuis
# l'autoload Texts. Répond à deux questions : combien de documents sont
# effectivement passés en français, et les blocs chiffrés sont-ils intacts.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
mod="$root/gdpatch-test/GDPatch/mods/flux_fr"

python3 "$here/gen_texts_gd.py" "$root/work/texts_corpus.json" \
	"$mod/texts.gd" "$root/work/translation_texts.json"
python3 "$here/gen_ingame_check.py" "$here/ingame/bilan_integration.gd"
cp "$here/ingame/bilan_integration.gd" "$mod/data/gdpatch/mods/flux_fr/mod.gd"

cd "$root/gdpatch-test"
timeout 180 env LD_PRELOAD="$PWD/libgdpatch_loader.so" ./flux-empyrean.x86_64 \
	--quit-after 250 2>&1 | grep -aE "BILAN|CORPUS-FR|NON APPLIQUE|Parse Error" || true
