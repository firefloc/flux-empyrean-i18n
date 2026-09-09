#!/usr/bin/env python3
"""Fait fabriquer au jeu ses propres scènes traduites, au premier lancement.

Le problème que ça résout. Les 205 libellés d'interface vivent dans 47 scènes.
Jusqu'ici on les réécrivait hors ligne avec Godot et on livrait 5,9 Mo de `.scn`
dans le mod. Ces fichiers sont des copies de ceux de ChillCash — on ne peut donc
ni les distribuer, ni demander à un joueur d'installer Godot pour les produire.
Le parcours joueur était bloqué des deux côtés.

La solution. Le jeu **est** un moteur Godot. Au premier lancement, le mod lui
fait charger chaque scène, muter `_bundled.variants` — où une `PackedScene`
range ses chaînes, désignées par indice depuis ses nœuds — et écrire le résultat
dans son propre dossier de mod avec `ResourceSaver`. Les lancements suivants
lisent ces fichiers, que GDPatch superpose au pack.

Pourquoi pas simplement muter en mémoire à chaque lancement : essayé et mesuré,
ça ne rend que 65 des 205 chaînes dans l'arbre instancié, contre 180 pour les
fichiers. Voir ETAT.md. Écrire sur disque garde le bon chiffre sans rien
redistribuer.

Trois conséquences, toutes bonnes :
  - le mod distribuable ne contient aucun fichier du jeu ;
  - il ne vise plus une build précise : les scènes se régénèrent quand le jeu
    change, puisque la marque de fraîcheur suit les cibles de remap, qui portent
    l'empreinte du contenu ;
  - le joueur n'installe ni Godot ni Python.

Le code produit est ajouté à la source régénérée de `Scripts/texts.gd`, un
autoload dont on maîtrise déjà tout le contenu : pas de nouvelle cible de patch,
et les autoloads s'exécutent avant la scène principale. `@@MOD_DIR@@` est
remplacé par le patcher Lua, seul à connaître le chemin du mod.

Usage: gen_scenes_gd.py <traduction_scenes.json> <sortie.gd>
"""

from __future__ import annotations

import json
import sys


def gd_str(s: str) -> str:
    out = s.replace("\\", "\\\\").replace('"', '\\"')
    return out.replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")


GABARIT = '''

# --- Scènes traduites, fabriquées par le jeu lui-même -----------------------
#
# Généré par tools/gen_scenes_gd.py — ne pas éditer à la main.

const FR_SCENES := {gabarit_scenes}

# Renseigné par patcher.lua au chargement : lui seul connaît le chemin du mod.
const MOD_DIR := "@@MOD_DIR@@"


func _ready() -> void:
\t_fabriquer_les_scenes()


# La cible réelle d'une scène. Godot remplace chaque `.tscn` par un renvoi vers
# `.godot/exported/<hash>/export-<md5>-<nom>.scn`. Écrire ailleurs ne fait rien,
# silencieusement — et ce chemin porte l'empreinte du contenu, donc il change à
# chaque mise à jour du jeu. C'est ce qui nous sert de marque de fraîcheur.
func _cible_remap(chemin: String) -> String:
\tvar renvoi := chemin + ".remap"
\tif not FileAccess.file_exists(renvoi):
\t\treturn ""
\tfor ligne in FileAccess.get_file_as_string(renvoi).split("\\n"):
\t\tif ligne.begins_with("path="):
\t\t\treturn ligne.split("\\"")[1]
\treturn ""


func _fabriquer_les_scenes() -> void:
\tif MOD_DIR.begins_with("@@"):
\t\tprint("SCENES chemin du mod non renseigne, scenes laissees en anglais")
\t\treturn

\tvar cibles := {{}}
\tvar signature := ""
\tfor chemin in FR_SCENES:
\t\tvar cible := _cible_remap(chemin)
\t\tif cible.is_empty():
\t\t\tcontinue
\t\tcibles[chemin] = cible
\t\tsignature += cible

\t# La marque porte la signature des cibles. Le jeu change, elle change, et
\t# les scènes se refont — sans quoi l'interface repasserait en anglais sans
\t# le moindre message, ce qui est le mode d'echec habituel par ici.
\tvar marque := MOD_DIR + "/data/.genere"
\tvar attendue := signature.sha256_text()
\tif FileAccess.file_exists(marque) and FileAccess.get_file_as_string(marque).strip_edges() == attendue:
\t\treturn

\tvar ecrites := 0
\tvar chaines := 0
\tvar hors_champ := 0
\tvar echecs := 0
\tfor chemin in cibles:
\t\tvar scene = ResourceLoader.load(chemin, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
\t\tif scene == null:
\t\t\techecs += 1
\t\t\tcontinue
\t\tvar bundled: Dictionary = scene.get("_bundled")
\t\tif bundled == null or not bundled.has("variants"):
\t\t\techecs += 1
\t\t\tcontinue
\t\tvar variants: Array = bundled["variants"]
\t\tvar touche := false
\t\tfor cle in FR_SCENES[chemin]:
\t\t\tvar i := int(cle)
\t\t\t# Un indice hors champ, ou qui ne designe plus une chaine, veut dire
\t\t\t# que la scene a change depuis la traduction. On passe : mieux vaut
\t\t\t# une ligne en anglais qu'une scene corrompue.
\t\t\tif i < 0 or i >= variants.size() or not variants[i] is String:
\t\t\t\thors_champ += 1
\t\t\t\tcontinue
\t\t\tvariants[i] = FR_SCENES[chemin][cle]
\t\t\tchaines += 1
\t\t\ttouche = true
\t\tif not touche:
\t\t\tcontinue
\t\tbundled["variants"] = variants
\t\tscene.set("_bundled", bundled)

\t\tvar destination: String = MOD_DIR + "/data/" + (cibles[chemin] as String).trim_prefix("res://")
\t\tDirAccess.make_dir_recursive_absolute(destination.get_base_dir())
\t\tif ResourceSaver.save(scene, destination) == OK:
\t\t\tecrites += 1
\t\telse:
\t\t\techecs += 1

\tvar f := FileAccess.open(marque, FileAccess.WRITE)
\tif f:
\t\tf.store_string(attendue)
\t\tf.close()

\tprint("SCENES %d scenes ecrites, %d chaines, %d hors champ, %d echecs"
\t\t% [ecrites, chaines, hors_champ, echecs])
\tprint("SCENES fabriquees pour cette version du jeu — relance pour les voir.")
'''


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    traduction = json.load(open(sys.argv[1], encoding="utf-8"))
    traduction = traduction.get("chaines", traduction)

    blocs = []
    total = 0
    for chemin, noeuds in sorted(traduction.items()):
        paires = [
            f'\t\t"{i}": "{gd_str(v)}",'
            for i, v in sorted(noeuds.items(), key=lambda kv: int(kv[0]))
            if v
        ]
        if not paires:
            continue
        total += len(paires)
        blocs.append(f'\t"{gd_str(chemin)}": {{\n' + "\n".join(paires) + "\n\t},")
    corps = "{\n" + "\n".join(blocs) + "\n}" if blocs else "{}"

    with open(sys.argv[2], "a", encoding="utf-8") as sortie:
        sortie.write(GABARIT.replace("{gabarit_scenes}", corps).replace("{{}}", "{}"))
    print(f"{sys.argv[2]}: {total} chaines de scene dans {len(blocs)} scenes")


if __name__ == "__main__":
    main()
