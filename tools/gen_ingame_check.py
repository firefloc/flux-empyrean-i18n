#!/usr/bin/env python3
"""Génère le contrôle en jeu à partir de `frozen_segments.json`.

Écrire ce contrôle à la main revenait à maintenir deux listes de segments
gelés, et l'une des deux finissait par oublier un bloc — c'est arrivé : le
chiffré de 23 lettres de `Tower Messages` manquait aux deux. Le script le
génère désormais depuis la source unique.

Usage: gen_ingame_check.py <sortie.gd>
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"

MODELE = '''# Généré par tools/gen_ingame_check.py — ne pas éditer à la main.
#
# Lit le corpus depuis l'autoload `Texts` avec le mod chargé, et vérifie que
# chaque segment gelé a survécu au cycle fusion → génération → patch. Un seul
# caractère en trop dans un bloc Vigenère décale tout le message déchiffré.
extends Node

const GELES := {geles}

# Les six blocs Vigenère dont la clé est connue, avec la clé que le joueur saisit.
const DECHIFFRE := [
	["A True Plan", 0, "wim"],
	["A True Plan", 1, "wim"],
	["Celestial Signs", 5, "dcdr"],
	["Inexistant Inscription", 0, "xeres"],
	["Message", 0, "minos"],
	["Ritual for a Proper God", 0, "feodor"],
]


func _ready() -> void:
\tawait get_tree().process_frame
\tvar docs: Dictionary = get_node("/root/Texts").texts
\tvar accents := 0
\tfor titre in docs:
\t\tvar texte := "\\n".join(PackedStringArray(docs[titre]))
\t\tif texte.contains("é") or texte.contains("è") or texte.contains("à"):
\t\t\taccents += 1
\tprint("BILAN documents servis : ", docs.size(), " | portant des accents : ", accents)

\tvar intacts := 0
\tvar casses := 0
\tfor entree in GELES:
\t\tvar titre: String = entree[0]
\t\tvar page: int = entree[1]
\t\tvar segment: String = entree[2]
\t\tif not docs.has(titre) or page >= (docs[titre] as Array).size():
\t\t\tprint("BILAN MANQUANT ", titre, " p", page)
\t\t\tcasses += 1
\t\t\tcontinue
\t\tif (docs[titre][page] as String).contains(segment):
\t\t\tintacts += 1
\t\telse:
\t\t\tprint("BILAN CASSÉ ", titre, " p", page, " : ", segment.substr(0, 40))
\t\t\tcasses += 1
\tprint("BILAN segments gelés intacts : ", intacts, " / cassés : ", casses)

\t# Les blocs chiffrés doivent rendre le clair anglais SUIVI de sa traduction.
\tvar scene: PackedScene = load("res://Scenes/passage.tscn")
\tvar traduits := 0
\tfor essai in DECHIFFRE:
\t\tvar passage = scene.instantiate()
\t\tadd_child(passage)
\t\tpassage.setup(0, docs[essai[0]][essai[1]], essai[2])
\t\tvar rendu: String = passage.get_node("RichTextLabel").text
\t\tif rendu.split("\\n\\n").size() > 1:
\t\t\ttraduits += 1
\t\telse:
\t\t\tprint("BILAN déchiffrement sans traduction : ", essai[0], " clé ", essai[2])
\t\tpassage.queue_free()
\tprint("BILAN clairs traduits : ", traduits, " / ", DECHIFFRE.size())
'''


def gd_str(s: str) -> str:
    out = s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\t", "\\t")
    return f'"{out}"'


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    frozen = json.loads((WORK / "frozen_segments.json").read_text(encoding="utf-8"))
    entrees = []
    for doc, pages in sorted(frozen.items()):
        for page, segments in sorted(pages.items(), key=lambda kv: int(kv[0])):
            for seg in segments:
                entrees.append(f"\t[{gd_str(doc)}, {int(page)}, {gd_str(seg['segment'])}],")
    bloc = "[\n" + "\n".join(entrees) + "\n]"
    Path(sys.argv[1]).write_text(MODELE.format(geles=bloc), encoding="utf-8")
    print(f"{sys.argv[1]} : {len(entrees)} segments à contrôler")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
