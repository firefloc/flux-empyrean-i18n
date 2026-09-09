#!/usr/bin/env python3
"""Regenere res://Scripts/texts.gd en clair a partir du corpus JSON.

Le script d'origine est un autoload de donnees pures : aucune methode, quatre
variables (texts, discoveries, authors, favorites). On peut donc le remplacer
par une source GDScript equivalente, que le moteur compile au chargement.

Usage: gen_texts_gd.py <corpus.json> <sortie.gd> [<traduction.json>]
"""
import json
import os
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

	# Les libellés d'interface ne vivent pas dans le corpus mais dans les
	# scènes, et rien ne les relit après coup : on les remplace sur place dans
	# l'arbre affiché. La fonction est produite par gen_scenes_gd.py, qui seul
	# dispose des paires — sans elle, la bascule reste celle des documents.
	var libelles := 0
	if has_method("basculer_les_scenes"):
		libelles = call("basculer_les_scenes", _en_version_originale)

	print("VO " + ("version originale" if _en_version_originale else "traduction")
		+ " (" + str(texts.size()) + " documents, "
		+ str(libelles) + " libelles)")
	_rafraichir_le_journal()
	_afficher_la_langue()


# Un bandeau qui dit dans quelle langue on est.
#
# Il ne sert pas qu'à faire joli. Certains textes sont figés au moment où on les
# ouvre — le texte d'un disque est recopié dans une variable au clic, et F1 ne
# le rattrape plus. Sans indicateur, le joueur voit de l'anglais et ne sait pas
# s'il regarde la version originale ou un trou de traduction.
#
# Le libellé est le code de langue, pas une phrase : le mod est bâti par langue
# et n'a pas de texte d'interface à lui. « EN » et « FR » se lisent partout.
const CODE_LANGUE := "@@CODE_LANGUE@@"

var _bandeau: CanvasLayer = null
var _bandeau_etiquette: Label = null
var _bandeau_generation := 0


func _preparer_le_bandeau() -> void:
	if is_instance_valid(_bandeau):
		return
	_bandeau = CanvasLayer.new()
	# Au-dessus de l'interface du jeu, qui n'utilise pas de couche aussi haute.
	_bandeau.layer = 128
	var boite := PanelContainer.new()
	boite.set_anchors_preset(Control.PRESET_TOP_LEFT)
	boite.offset_top = 16
	boite.offset_left = 16
	# On ne veut pas intercepter les clics du joueur.
	boite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fond := StyleBoxFlat.new()
	fond.bg_color = Color(0, 0, 0, 0.65)
	fond.set_corner_radius_all(6)
	fond.set_content_margin_all(8)
	boite.add_theme_stylebox_override("panel", fond)
	_bandeau_etiquette = Label.new()
	_bandeau_etiquette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boite.add_child(_bandeau_etiquette)
	_bandeau.add_child(boite)
	get_tree().root.add_child(_bandeau)


func _afficher_la_langue() -> void:
	_preparer_le_bandeau()
	if not is_instance_valid(_bandeau_etiquette):
		return
	var traduite := CODE_LANGUE.to_upper()
	_bandeau_etiquette.text = ("F1  " + traduite + "  [EN]" if _en_version_originale
		else "F1  [" + traduite + "]  EN") + "    F2  \u21bb"
	_bandeau_etiquette.modulate = (Color(1, 0.85, 0.4) if _en_version_originale
		else Color(1, 1, 1, 0.75))
	_bandeau.visible = true


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
		elif evenement.keycode == KEY_F2:
			_recharger_les_textes()
			get_viewport().set_input_as_handled()


# F2 réapplique la langue courante à l'écran, sans rien recharger.
#
# Recharger la scène marcherait aussi, mais coûterait la position du joueur —
# au large, sur le bateau, c'est inacceptable. Et Godot ne sait pas recharger
# une scène « sans ses entités » : une PackedScene s'instancie entière.
#
# Or on n'a pas besoin de recharger. Ce qui manque après une transition de
# lieu, c'est que les libellés de la scène fraîchement chargée reviennent dans
# la langue du mod alors qu'on avait demandé la version originale. Repasser sur
# l'arbre suffit, et ne touche à rien d'autre.
#
# Ce que ça ne rattrape toujours pas : un texte déjà recopié dans une variable
# — celui d'un disque, pris au clic. Pour celui-là, re-cliquer le relit.
func _recharger_les_textes() -> void:
	var libelles := 0
	if has_method("basculer_les_scenes"):
		libelles = call("basculer_les_scenes", _en_version_originale)
	_rafraichir_le_journal()
	var flottants := _rejouer_les_textes_flottants()
	print("VO F2 textes reappliques (" + str(libelles) + " libelles, "
		+ str(flottants) + " flottants)")
	_afficher_la_langue()


# Les textes flottants du monde — ceux d'un disque qu'on vient d'ouvrir.
#
# Ils sont hors de portée d'un parcours d'arbre : `text_shower` est un Label3D
# éphémère qui joue sa machine à écrire puis se libère, et la phrase a été lue
# dans le corpus au moment du clic. Rien à échanger, donc.
#
# Mais `Disc.show_text()` est une méthode publique qui relit
# `Texts.texts[titre][passage]` à l'appel, et — c'est ce qui la rend utilisable
# ici — elle ne touche pas à la découverte : `discover()` est appelé ailleurs,
# par le clic. La rappeler ne débloque donc aucun succès.
func _rejouer_les_textes_flottants() -> int:
	var rejoues := 0
	var pile: Array[Node] = [get_tree().root]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		# Un disque, et lui seul : `is_discovered` distingue un Disc d'un autre
		# nœud qui aurait un `show_text`.
		if n.has_method("show_text") and n.has_method("is_discovered"):
			var montre := n.get_node_or_null("TextShower")
			if montre != null:
				# On ne le libère pas sur-le-champ : son animation tient des
				# rappels sur lui-même, et les couper net planterait. On le cache
				# — sinon les deux phrases se superposeraient — et on le renomme,
				# sans quoi le garde-fou de `show_text()` refuserait de rejouer.
				# Il se libère ensuite tout seul, à la fin de son tween.
				montre.name = "TextShowerRemplace"
				if montre is Node3D:
					montre.visible = false
				montre.queue_free()
				n.call("show_text")
				rejoues += 1
		for e in n.get_children():
			pile.append(e)
	return rejoues
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
    langue = os.environ.get("LOCALE", "fr")
    lines.append(BASCULE.replace("@@CODE_LANGUE@@", langue))
    open(sys.argv[2], "w", encoding="utf-8").write("\n".join(lines))
    print(f"{sys.argv[2]}: {len(data['texts'])} documents")


if __name__ == "__main__":
    main()
