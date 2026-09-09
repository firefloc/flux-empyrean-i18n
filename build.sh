#!/usr/bin/env bash
# Construit le mod de traduction pour une langue donnée.
#
#   ./build.sh <chemin de l'exécutable du jeu> [langue]
#
# La langue par défaut est `fr`. Tout ce qui est propre à une langue vit dans
# `locales/<langue>/` ; le reste — extraction, inventaire des verrous, détection
# des segments gelés, contrôles — est identique pour toutes les langues.
#
# Le mod produit atterrit dans `build/<langue>/`. Rien n'est copié dans le jeu :
# c'est `./install.sh` qui s'en charge, séparément et volontairement.
set -euo pipefail

ici="$(cd "$(dirname "$0")" && pwd)"
jeu="${1:?usage: build.sh <exécutable du jeu> [langue]}"
export LOCALE="${2:-fr}"
locale_dir="$ici/locales/$LOCALE"
work="$ici/work"
sortie="$ici/build/$LOCALE"

[ -f "$jeu" ] || { echo "introuvable : $jeu" >&2; exit 1; }
[ -d "$locale_dir" ] || { echo "langue inconnue : $locale_dir" >&2; exit 1; }

echo "== 1/6 extraction du pack"
WORK="$work" "$ici/tools/build.sh" extract "$jeu" >/dev/null

echo "== 2/6 décompilation des scripts et relevé des faits du jeu"
"$ici/tools/dump_sources.sh" "$(dirname "$jeu")" | tail -1
python3 "$ici/tools/dump_script_strings.py"
GAME_EXE="$jeu" OUT_DIR="$work" godot --headless --path "$ici/tools/inspect" \
	-s "$ici/tools/inspect/dump_texts.gd" >/dev/null 2>&1
GAME_EXE="$jeu" OUT_DIR="$work" godot --headless --path "$ici/tools/godot" \
	-s "$ici/tools/godot/dump_text.gd" >/dev/null 2>&1
GAME_EXE="$jeu" OUT_DIR="$work" godot --headless --path "$ici/tools/godot" \
	-s "$ici/tools/godot/dump_ui.gd" >/dev/null 2>&1
python3 "$ici/tools/merge_scene_sources.py"
python3 "$ici/tools/build_locks.py" >/dev/null
python3 "$ici/tools/build_frozen.py" >/dev/null
python3 "$ici/tools/crack_vigenere.py"
python3 "$ici/tools/check_acrostics.py" | sed -n '/réponse d.énigme/,+3p'
# La carte que l'éditeur web charge : des nombres de pages et des empreintes,
# jamais de texte du jeu. Elle suit la version du jeu, donc on la régénère ici.
python3 "$ici/tools/build_index_web.py"

echo "== 3/6 contrôle de la traduction"
python3 "$ici/tools/verify_locale.py" || {
	echo "traduction refusée : corrige les erreurs ci-dessus avant de construire" >&2
	exit 1
}

echo "== 4/6 génération des patchs"
mkdir -p "$sortie"
python3 "$ici/tools/locale_to_work.py"
python3 "$ici/tools/gen_texts_gd.py" "$work/texts_corpus.json" \
	"$sortie/texts.gd" "$work/translation_texts.json"
python3 "$ici/tools/gen_strings_lua.py" "$sortie/strings.lua"
python3 "$ici/tools/build_answer_patch.py" >/dev/null
python3 "$ici/tools/build_decrypt_patch.py" >/dev/null
python3 "$ici/tools/gen_answers_lua.py" "$sortie/answers.lua"

echo "== 5/6 traduction des scènes"
# Le mod ne livre aucune scène : il fait fabriquer au jeu, à son premier
# lancement, les `.scn` traduits depuis sa propre copie. Voir ETAT.md — la
# mutation en mémoire seule ne rendait que 65 chaînes sur 205, l'écriture sur
# disque en rend 180, comme la réécriture hors ligne qu'elle remplace.
python3 "$ici/tools/remap_scenes.py" "$work/strings_scenes.json" | tail -1
python3 "$ici/tools/gen_scenes_gd.py" "$work/translation_scenes.json" "$sortie/texts.gd"

echo "== 6/6 assemblage"
cp "$ici/mod/patcher.lua" "$sortie/patcher.lua"
sed "s/{{LANGUE}}/$LOCALE/g" "$ici/mod/gdpatch_mod.toml" > "$sortie/gdpatch_mod.toml"
echo
echo "mod prêt : $sortie"
du -sh "$sortie"
