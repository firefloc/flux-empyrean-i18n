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

Au passage, on relève les paires anglais↔français
------------------------------------------------

F1 rebascule le jeu en version originale. Pour les documents, `patcher.lua`
prend l'anglais dans le pack du joueur. Pour les scènes, l'occasion est ici :
au moment où on remplace `variants[i]`, la valeur qu'on écrase **est**
l'anglais, lu dans la copie du joueur. On l'écrit dans `data/vo_scenes.json`,
qui ne quitte jamais sa machine — le mod distribué ne contient toujours aucune
prose du jeu.

Deux garde-fous, parce que chacun correspond à une façon de casser le jeu :

- **Les chaînes que la logique utilise comme clé ne sont jamais relevées.**
  `Disc.text` n'est pas un libellé : c'est un titre de document, lu ensuite en
  `Texts.discoveries[text][passage]`. `The Great Joke` est à la fois ce genre de
  clé et un libellé traduit ailleurs. Une bascule qui l'échangerait par valeur
  réécrirait la clé et casserait la découverte, sans message. On construit donc
  l'union des chaînes servant de clé — titres du corpus, mots-réponses, alias,
  propriétés `answer`/`fish_id`/… — et on écarte toute paire qui y touche d'un
  côté ou de l'autre.
- **Une scène déjà française ne fournit pas d'anglais.** Si la marque de
  fraîcheur est effacée alors que les `.scn` traduits sont en place, GDPatch les
  superpose et `ResourceLoader` rend du français : on relèverait `fr → fr` et F1
  ne ferait rien, en silence. On compare donc avant d'écrire, et on compte les
  manques à voix haute.

Usage: gen_scenes_gd.py <traduction_scenes.json> <sortie.gd>
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
WORK = Path(os.environ.get("WORK", RACINE / "work"))

# Les propriétés dont la valeur sert de clé à la logique du jeu, jamais de
# libellé. Elles ne sont pas traduites ; elles servent ici à repérer les
# chaînes qu'une bascule par valeur ne doit pas toucher.
PROPS_CLES = {
    "answer", "name_answer", "title_answer", "fish_id", "hostname",
    "uri", "sound_path", "direction", "tower", "item_0/text",
}


def gd_str(s: str) -> str:
    out = s.replace("\\", "\\\\").replace('"', '\\"')
    return out.replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")


def charger(nom: str) -> dict:
    chemin = WORK / nom
    if not chemin.is_file():
        raise SystemExit(
            f"{nom} manquant dans {WORK}.\n"
            "Il sert à repérer les chaînes que la logique du jeu utilise comme clé ;\n"
            "sans lui on ne peut pas relever les paires anglais↔français sans risque."
        )
    return json.load(open(chemin, encoding="utf-8"))


def cles_de_logique() -> set[str]:
    """Les chaînes que le jeu lit comme clé, et qu'une bascule ne doit jamais toucher."""
    corpus = charger("texts_corpus.json")
    carte = charger("scene_prop_map.json")
    anglais = charger("strings_scenes.json")

    cles: set[str] = set()
    for champ in ("texts", "discoveries", "authors"):
        cles |= set(corpus.get(champ, {}))

    alias = WORK / "answer_aliases.json"
    if alias.is_file():
        table = json.load(open(alias, encoding="utf-8"))
        cles |= set(table)
        for valeur in table.values():
            if isinstance(valeur, str):
                cles.add(valeur)
            elif isinstance(valeur, (list, tuple, set)):
                cles |= {str(v) for v in valeur}

    for scene, indices in carte.items():
        for indice, usages in indices.items():
            valeur = anglais.get(scene, {}).get(indice)
            if not valeur:
                continue
            for usage in usages:
                # `Disc.text` porte un titre de document, pas un libellé.
                if usage["prop"] in PROPS_CLES or (
                    "disc.tscn" in usage["type"] and usage["prop"] == "text"
                ):
                    cles.add(valeur)
    return cles


GABARIT = '''

# --- Scènes traduites, fabriquées par le jeu lui-même -----------------------
#
# Généré par tools/gen_scenes_gd.py — ne pas éditer à la main.

const FR_SCENES := {gabarit_scenes}

# Les indices dont on ne relève pas l'anglais : leur chaîne sert aussi de clé à
# la logique du jeu, et une bascule par valeur la réécrirait. Voir l'en-tête de
# gen_scenes_gd.py — le cas concret est un titre de document qui est ailleurs un
# libellé de bouton.
const VO_EXCLU := {gabarit_exclu}

# Renseigné par patcher.lua au chargement : lui seul connaît le chemin du mod.
const MOD_DIR := "@@MOD_DIR@@"

# Les trois propriétés qui portent du texte affiché dans les scènes traduites.
# Rien d'autre n'est touché : `answer`, `fish_id` et consorts sont des clés.
const PROPRIETES_TEXTE := ["text", "display_text", "placeholder_text"]

# Relevées dans le pack du joueur quand les scènes sont fabriquées, jamais
# distribuées. Vides tant que la fabrication n'a pas eu lieu : F1 ne touchera
# alors pas aux scènes, plutôt que d'échanger à moitié.
var _vo_scenes := {{}}  # français -> anglais
var _fr_scenes := {{}}  # anglais -> français


func _ready() -> void:
\t_fabriquer_les_scenes()
\t_charger_les_paires()


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


func _fichier_des_paires() -> String:
\treturn MOD_DIR + "/data/vo_scenes.json"


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
\t#
\t# Le fichier de paires compte autant que la marque : une installation faite
\t# avant que F1 ne couvre les scenes a la marque mais pas les paires, et il
\t# faut refabriquer pour les relever.
\tvar marque := MOD_DIR + "/data/.genere"
\tvar attendue := signature.sha256_text()
\tvar a_jour := FileAccess.file_exists(marque) \\
\t\tand FileAccess.get_file_as_string(marque).strip_edges() == attendue
\tif a_jour and FileAccess.file_exists(_fichier_des_paires()):
\t\treturn

\tvar ecrites := 0
\tvar chaines := 0
\tvar hors_champ := 0
\tvar echecs := 0
\tvar sans_vo := 0
\tvar paires := {{}}
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
\t\tvar exclus: Array = VO_EXCLU.get(chemin, [])
\t\tvar touche := false
\t\tfor cle in FR_SCENES[chemin]:
\t\t\tvar i := int(cle)
\t\t\t# Un indice hors champ, ou qui ne designe plus une chaine, veut dire
\t\t\t# que la scene a change depuis la traduction. On passe : mieux vaut
\t\t\t# une ligne en anglais qu'une scene corrompue.
\t\t\tif i < 0 or i >= variants.size() or not variants[i] is String:
\t\t\t\thors_champ += 1
\t\t\t\tcontinue
\t\t\tvar traduite: String = FR_SCENES[chemin][cle]
\t\t\tvar origine: String = variants[i]
\t\t\t# Ce qu'on ecrase est l'anglais de la copie du joueur — sauf si la
\t\t\t# scene traduite est deja superposee, auquel cas on lit du francais et
\t\t\t# la paire ne vaut rien. On le dit plutot que de relever `fr -> fr`.
\t\t\tif exclus.has(cle):
\t\t\t\tpass
\t\t\telif origine == traduite:
\t\t\t\tsans_vo += 1
\t\t\telse:
\t\t\t\tpaires[traduite] = origine
\t\t\tvariants[i] = traduite
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

\tvar p := FileAccess.open(_fichier_des_paires(), FileAccess.WRITE)
\tif p:
\t\tp.store_string(JSON.stringify(paires))
\t\tp.close()

\tprint("SCENES %d scenes ecrites, %d chaines, %d hors champ, %d echecs"
\t\t% [ecrites, chaines, hors_champ, echecs])
\tprint("SCENES %d paires VO relevees" % paires.size()
\t\t+ (", %d sans VO (scene deja traduite)" % sans_vo if sans_vo > 0 else ""))
\tprint("SCENES fabriquees pour cette version du jeu — relance pour les voir.")


# Les paires relevees lors de la fabrication. Sans elles, F1 laisse les scenes
# telles quelles : mieux vaut une bascule partielle annoncee qu'une bascule a
# moitie faite.
func _charger_les_paires() -> void:
\tif MOD_DIR.begins_with("@@") or not FileAccess.file_exists(_fichier_des_paires()):
\t\treturn
\tvar brut = JSON.parse_string(FileAccess.get_file_as_string(_fichier_des_paires()))
\tif not brut is Dictionary:
\t\treturn
\tfor traduite in brut:
\t\t_vo_scenes[traduite] = brut[traduite]
\t\t_fr_scenes[brut[traduite]] = traduite


# Remet le texte affiche dans l'autre langue, sur place. On parcourt l'arbre
# plutot que de recharger : un rechargement perdrait l'etat de la partie.
#
# Ce que ca ne couvre pas, volontairement : le texte deja recopie dans une
# variable par un script, et l'animation machine a ecrire, qui reecrit la
# propriete apres nous.
func basculer_les_scenes(vers_origine: bool) -> int:
\tvar table: Dictionary = _vo_scenes if vers_origine else _fr_scenes
\tif table.is_empty():
\t\treturn 0
\tvar changees := 0
\tvar pile: Array[Node] = [get_tree().root]
\twhile not pile.is_empty():
\t\tvar noeud: Node = pile.pop_back()
\t\tfor propriete in PROPRIETES_TEXTE:
\t\t\tvar valeur = noeud.get(propriete)
\t\t\tif valeur is String and table.has(valeur):
\t\t\t\tnoeud.set(propriete, table[valeur])
\t\t\t\tchangees += 1
\t\tfor enfant in noeud.get_children():
\t\t\tpile.append(enfant)
\treturn changees
'''


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    traduction = json.load(open(sys.argv[1], encoding="utf-8"))
    traduction = traduction.get("chaines", traduction)

    anglais = charger("strings_scenes.json")
    cles = cles_de_logique()

    blocs = []
    exclusions: dict[str, list[str]] = {}
    relevables: set[str] = set()
    total = 0
    for chemin, noeuds in sorted(traduction.items()):
        paires = []
        for indice, valeur in sorted(noeuds.items(), key=lambda kv: int(kv[0])):
            if not valeur:
                continue
            paires.append(f'\t\t"{indice}": "{gd_str(valeur)}",')
            origine = anglais.get(chemin, {}).get(indice)
            if valeur in cles or (origine and origine in cles):
                exclusions.setdefault(chemin, []).append(indice)
            elif origine:
                relevables.add(valeur)
        if not paires:
            continue
        total += len(paires)
        blocs.append(f'\t"{gd_str(chemin)}": {{\n' + "\n".join(paires) + "\n\t},")
    corps = "{\n" + "\n".join(blocs) + "\n}" if blocs else "{}"

    if exclusions:
        lignes = [
            '\t"%s": [%s],' % (gd_str(c), ", ".join(f'"{i}"' for i in sorted(v, key=int)))
            for c, v in sorted(exclusions.items())
        ]
        corps_exclu = "{\n" + "\n".join(lignes) + "\n}"
    else:
        corps_exclu = "{}"

    gabarit = (
        GABARIT.replace("{gabarit_scenes}", corps)
        .replace("{gabarit_exclu}", corps_exclu)
        .replace("{{}}", "{}")
    )
    with open(sys.argv[2], "a", encoding="utf-8") as sortie:
        sortie.write(gabarit)

    ecartees = sum(len(v) for v in exclusions.values())
    print(f"{sys.argv[2]}: {total} chaines de scene dans {len(blocs)} scenes")
    # Deux comptes distincts, parce que les confondre a deja coute une soiree :
    # `total` compte des positions dans les scenes, la table des paires est
    # indexee par la chaine et fond les doublons. Le jeu annoncera le second.
    print(f"{sys.argv[2]}: {len(relevables)} paires VO distinctes a relever "
          f"({total} positions, {ecartees} ecartee(s) : chaine servant de cle au jeu)")
    for chemin, indices in sorted(exclusions.items()):
        for indice in sorted(indices, key=int):
            origine = anglais.get(chemin, {}).get(indice, "?")
            print(f"    ecartee : {chemin.split('/')[-1]} [{indice}] {origine!r}")


if __name__ == "__main__":
    main()
