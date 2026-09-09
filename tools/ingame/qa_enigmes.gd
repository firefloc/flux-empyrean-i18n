# Recette des énigmes : injecte une réponse française, appelle la vérification
# du jeu, et contrôle **l'effet propre à cette énigme**.
#
# Un diff d'état générique ne marche pas : des tweens d'ambiance déplacent des
# nœuds en permanence, et le bruit noie le signal. On encode donc, pour chaque
# énigme, ce qu'elle fait quand elle est résolue — relevé dans les sources
# décompilées, pas deviné.
extends Node

const CAS := [
	{
		"scene": "res://Locations/Tower of Languages/tower_of_languages.tscn",
		"effet": "invisible",  # tower_block.gd : visible = false
		"bonne": "inintelligible", "mauvaise": "nimportequoi",
	},
	{
		"scene": "res://Locations/Acropolis/acropolis.tscn",
		"effet": "var:solved",  # follower.gd : solved = true
		"bonne": "Nolud", "mauvaise": "nimportequoi",
	},
	{
		"scene": "res://Locations/Hall of Forms/hall_of_forms.tscn",
		"effet": "lampe_verte",  # table.gd : OmniLight3D.light_color = GREEN
		"bonne": "le planétarium", "mauvaise": "nimportequoi",
	},
	{
		"scene": "res://Locations/Superserver/superserver.tscn",
		"effet": "signal:correct",  # super_terminal.gd : emit_signal("correct")
		"bonne": "immortel", "mauvaise": "nimportequoi",
	},
	{
		"scene": "res://Locations/Parallel Exhibition/parallel_exhibition.tscn",
		"effet": "decouverte:Parallel Exhibition",  # floor_tile.gd : LocationManager.discover
		"bonne": "oui", "mauvaise": "nimportequoi",
	},
	{
		"scene": "res://Locations/Deep Flux Lab/deep_flux_lab.tscn",
		"effet": "porte_descend",  # entrance_terminal.gd : tween EntranceDoors vers y = -5
		"bonne": "la tablette", "mauvaise": "nimportequoi",
	},
]

var signal_recu := false


func _ready() -> void:
	await get_tree().process_frame
	var gt := get_node_or_null("/root/GlobalTime")
	if gt:
		gt.paused = false
		gt.player_wait = false
		gt.wait = false

	var reussis := 0
	for cas in CAS:
		if await essayer(cas):
			reussis += 1
	print("QA-ENIGMES bilan : %d / %d énigmes acceptent le français et refusent le faux"
		% [reussis, CAS.size()])
	get_tree().quit()


func essayer(cas: Dictionary) -> bool:
	var ps: PackedScene = load(cas["scene"])
	if ps == null:
		print("QA-ENIGMES scène introuvable : ", cas["scene"])
		return false
	var racine := ps.instantiate()
	add_child(racine)
	for i in 5:
		await get_tree().process_frame

	var bons := 0
	var faux := 0
	var testes := 0
	for noeud in porteurs(racine):
		var champ := champ_de_saisie(noeud)
		if champ == null:
			continue
		testes += 1
		# Le faux d'abord : si l'énigme s'ouvre dessus, le test est nul.
		if await reagit(noeud, champ, cas["mauvaise"], cas["effet"]):
			faux += 1
		if await reagit(noeud, champ, cas["bonne"], cas["effet"]):
			bons += 1

	var ok := bons > 0 and faux == 0
	print("QA-ENIGMES %s %-30s %2d saisie(s) | « %s » -> %d | « %s » -> %d"
		% ["OK   " if ok else "ÉCHEC", cas["scene"].get_file(), testes,
		   cas["bonne"], bons, cas["mauvaise"], faux])
	racine.visible = false
	return ok


func reagit(noeud: Node, champ: LineEdit, saisie: String, effet: String) -> bool:
	signal_recu = false
	if effet.begins_with("signal:"):
		var nom := effet.split(":")[1]
		if noeud.has_signal(nom) and not noeud.is_connected(nom, _sur_signal):
			noeud.connect(nom, _sur_signal)
	if effet.begins_with("decouverte:"):
		var lieu := effet.split(":")[1]
		var loc := get_node_or_null("/root/Locations")
		if loc and (loc.discoveries as Dictionary).has(lieu):
			var etats: Array = loc.discoveries[lieu]
			for i in etats.size():
				etats[i] = false
			await get_tree().process_frame
	if effet == "porte_descend":
		var portes := noeud.get_parent().get_node_or_null("EntranceDoors")
		if portes:
			for t in get_tree().get_processed_tweens():
				t.kill()
			(portes as Node3D).position.y = 0.0
			await get_tree().process_frame
	var avant := mesurer(noeud, effet)
	champ.text = saisie
	noeud.check_text()
	for i in 3:
		await get_tree().process_frame
	return signal_recu or mesurer(noeud, effet) != avant


func mesurer(noeud: Node, effet: String) -> String:
	match effet:
		"invisible":
			return str((noeud as Node3D).visible)
		"var:solved":
			return str(noeud.get("solved"))
		"lampe_verte":
			var couleurs: Array[String] = []
			for l in descendants(noeud.get_parent()):
				if l is Light3D:
					couleurs.append(str((l as Light3D).light_color))
			couleurs.sort()
			return "|".join(couleurs)
		_ when effet.begins_with("decouverte:"):
			var lieu := effet.split(":")[1]
			var l := get_node_or_null("/root/Locations")
			return "" if l == null else str((l.discoveries as Dictionary).get(lieu, []))
		"porte_descend":
			var portes := noeud.get_parent().get_node_or_null("EntranceDoors")
			return "" if portes == null else str(snappedf((portes as Node3D).position.y, 0.01))
	return ""


func _sur_signal(_a = null) -> void:
	signal_recu = true


func descendants(racine: Node) -> Array[Node]:
	var out: Array[Node] = []
	if racine == null:
		return out
	var pile: Array[Node] = [racine]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		out.append(n)
		for e in n.get_children():
			pile.append(e)
	return out


func porteurs(racine: Node) -> Array[Node]:
	var out: Array[Node] = []
	for n in descendants(racine):
		if n.has_method("check_text"):
			out.append(n)
	return out


func champ_de_saisie(noeud: Node) -> LineEdit:
	for n in descendants(noeud):
		if n is LineEdit:
			return n
	return null
