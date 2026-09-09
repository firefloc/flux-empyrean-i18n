#!/usr/bin/env python3
"""Regenere res://Scripts/texts.gd en clair a partir du corpus JSON.

Le script d'origine est un autoload de donnees pures : aucune methode, quatre
variables (texts, discoveries, authors, favorites). On peut donc le remplacer
par une source GDScript equivalente, que le moteur compile au chargement.

Usage: gen_texts_gd.py <corpus.json> <sortie.gd> [<traduction.json>]
"""
import json
import sys


def gd_str(s: str) -> str:
    out = s.replace("\\", "\\\\").replace('"', '\\"')
    out = out.replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")
    return f'"{out}"'


def gd_value(v, indent: int = 1) -> str:
    pad = "\t" * indent
    if isinstance(v, str):
        return gd_str(v)
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    if v is None:
        return "null"
    if isinstance(v, list):
        if not v:
            return "[]"
        items = ",\n".join(f"{pad}\t{gd_value(e, indent + 1)}" for e in v)
        return f"[\n{items},\n{pad}]"
    if isinstance(v, dict):
        if not v:
            return "{}"
        items = ",\n".join(
            f"{pad}\t{gd_str(str(k))}: {gd_value(e, indent + 1)}" for k, e in v.items()
        )
        return f"{{\n{items},\n{pad}}}"
    raise TypeError(f"type non gere: {type(v)}")


# Revenir au texte d'origine, en jeu, d'une touche.
#
# Une traduction peut se tromper — sur un mot-réponse, sur une consigne, sur un
# nombre. Le joueur se retrouve alors bloqué sans savoir si c'est l'énigme ou le
# patch. F1 bascule le journal en anglais et le rebascule : il voit l'original,
# se débloque, et peut signaler ce qui cloche.
#
# Le texte anglais n'est pas distribué avec le mod : `patcher.lua` le prend dans
# le pack du joueur au chargement et l'injecte à la place de `@@TEXTS_VO@@`. Si
# la substitution n'a pas eu lieu, la bascule se désactive au lieu de planter.
BASCULE = '''
@@TEXTS_VO@@

var _en_version_originale := false


func _basculer_langue() -> void:
	if not has_meta("texts_vo") and not ("texts_vo" in self):
		print("VO indisponible : le texte d\'origine n\'a pas été injecté")
		return
	_en_version_originale = not _en_version_originale
	# On fusionne au lieu d'échanger. Certaines entrées n'existent que dans le
	# dictionnaire courant : `TextManager` y injecte au démarrage le texte du
	# tutoriel, absent du pack. Un échange sec les faisait disparaître — le texte
	# flottant du tutoriel repassait en anglais et n'en revenait pas.
	var avant := texts.duplicate(true)
	for titre in texts_vo:
		texts[titre] = texts_vo[titre]
	texts_vo = avant
	print("VO " + ("version originale" if _en_version_originale else "traduction")
		+ " (" + str(texts.size()) + " documents)")
	_rafraichir_le_journal()


# Le journal garde le document affiché dans `last_text` et sait se redessiner.
# Sans ça il faudrait fermer et rouvrir, ce qui rend la bascule inutilisable
# pour comparer deux formulations.
func _rafraichir_le_journal() -> void:
	for noeud in get_tree().get_nodes_in_group("journal"):
		if noeud.has_method("set_displayed_text") and noeud.get("last_text"):
			noeud.set_displayed_text(noeud.last_text)
			return
	var pile: Array[Node] = [get_tree().root]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		if n.has_method("set_displayed_text") and n.get("last_text"):
			n.set_displayed_text(n.last_text)
			return
		for enfant in n.get_children():
			pile.append(enfant)


func _unhandled_input(evenement: InputEvent) -> void:
	if evenement is InputEventKey and evenement.pressed and not evenement.echo:
		if evenement.keycode == KEY_F1:
			_basculer_langue()
			get_viewport().set_input_as_handled()
'''


def main() -> None:
    if len(sys.argv) not in (3, 4):
        raise SystemExit(__doc__)
    data = json.load(open(sys.argv[1], encoding="utf-8"))
    if len(sys.argv) == 4:
        tr = json.load(open(sys.argv[3], encoding="utf-8"))
        for key, body in tr.get("texts", {}).items():
            if key in data["texts"]:
                data["texts"][key] = body
        for field in ("discoveries", "authors"):
            for key, val in tr.get(field, {}).items():
                if key in data[field]:
                    data[field][key] = val

    lines = [
        "# Genere par tools/gen_texts_gd.py — ne pas editer a la main.",
        "extends Node",
        "",
    ]
    for name in ("texts", "discoveries", "authors", "favorites"):
        lines.append(f"var {name} = {gd_value(data[name])}")
        lines.append("")
    lines.append(BASCULE)
    open(sys.argv[2], "w", encoding="utf-8").write("\n".join(lines))
    print(f"{sys.argv[2]}: {len(data['texts'])} documents")


if __name__ == "__main__":
    main()
