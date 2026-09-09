# Sonde manuelle : appuie sur F1 à la place du joueur et mesure ce qui bascule.
#
# Ne fait pas partie du mod. Elle se greffe sur `Scripts/texts.gd` par un mod
# GDPatch temporaire qui se compose après celui de traduction — voir l'en-tête
# de tools/gen_scenes_gd.py pour ce que la bascule couvre et pourquoi.
#
# Le menu principal ne suffit pas à juger : F1 sert quand on est bloqué, donc
# devant le journal ou l'écran de pause. Ces deux scènes n'ont aucun effet de
# bord au chargement — `save_discoveries()` n'est appelé que par le bouton
# quitter — on peut donc les instancier pour les mesurer. C'est une mesure du
# mécanisme sur un banc, pas une partie réelle, et le compte le dit.

const SONDE_BANC := [
	"res://Scenes/pause_screen.tscn",
	"res://Scenes/journal.tscn",
]


func _enter_tree() -> void:
	_sonde_f1()


# Les nœuds Disc portent un titre de document dans `text`. Si la bascule y
# touche, `Texts.discoveries[text]` ne répond plus et la découverte est cassée.
func _sonde_disques() -> Array:
	var vus := []
	var pile: Array[Node] = [get_tree().root]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		if n.has_method("is_discovered"):
			vus.append(str(n.get_path()) + "=" + str(n.get("text")))
		for e in n.get_children():
			pile.append(e)
	vus.sort()
	return vus


# Combien de positions portent une chaîne qu'on sait basculer, et dans quel
# sens elles sont actuellement : [en français, en version originale].
func _sonde_compter(depuis: Node) -> Array:
	var en_fr := 0
	var en_vo := 0
	var pile: Array[Node] = [depuis]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		for p in PROPRIETES_TEXTE:
			var v = n.get(p)
			if not v is String:
				continue
			if _vo_scenes.has(v):
				en_fr += 1
			elif _fr_scenes.has(v):
				en_vo += 1
		for e in n.get_children():
			pile.append(e)
	return [en_fr, en_vo]


func _sonde_etat(vivant: Node, bancs: Dictionary, quand: String) -> void:
	var v := _sonde_compter(vivant)
	print("SONDE %s  menu vivant fr=%d vo=%d" % [quand, v[0], v[1]])
	for nom in bancs:
		var b := _sonde_compter(bancs[nom])
		print("SONDE %s  banc %s fr=%d vo=%d" % [quand, nom, b[0], b[1]])


func _sonde_f1() -> void:
	await get_tree().create_timer(2.0).timeout
	print("SONDE paires chargees = ", _vo_scenes.size())

	var vivant: Node = get_tree().current_scene if get_tree().current_scene else get_tree().root

	# Le banc : les écrans devant lesquels on appuie réellement sur F1.
	var banc := Node.new()
	get_tree().root.add_child(banc)
	var bancs := {}
	for chemin in SONDE_BANC:
		var paquet = load(chemin)
		if paquet == null:
			print("SONDE banc %s : chargement impossible" % chemin)
			continue
		var noeud: Node = paquet.instantiate()
		banc.add_child(noeud)
		bancs[chemin.get_file()] = noeud

	var disques_avant := _sonde_disques()
	var depart_vivant := _sonde_compter(vivant)
	var depart_banc := {}
	for nom in bancs:
		depart_banc[nom] = _sonde_compter(bancs[nom])
	_sonde_etat(vivant, bancs, "depart ")

	_basculer_langue()
	_sonde_etat(vivant, bancs, "apres  ")
	var apres_vivant := _sonde_compter(vivant)
	var apres_banc := {}
	for nom in bancs:
		apres_banc[nom] = _sonde_compter(bancs[nom])
	var disques_vo := _sonde_disques()

	_basculer_langue()
	_sonde_etat(vivant, bancs, "retour ")
	var retour_vivant := _sonde_compter(vivant)

	# Un aller réussi : plus rien en français, tout en version originale.
	var ok: bool = apres_vivant[0] == 0 and apres_vivant[1] == depart_vivant[0] + depart_vivant[1]
	var retour_ok: bool = retour_vivant == depart_vivant
	for nom in bancs:
		var d: Array = depart_banc[nom]
		var a: Array = apres_banc[nom]
		if a[0] != 0 or a[1] != d[0] + d[1]:
			ok = false
		if _sonde_compter(bancs[nom]) != d:
			retour_ok = false
	var disques_ok: bool = disques_avant == disques_vo and disques_avant == _sonde_disques()
	var cle_ok: bool = discoveries.has("The Great Joke")

	print("SONDE disques (%d) intacts = %s" % [disques_avant.size(), str(disques_ok)])
	print("SONDE cle 'The Great Joke' presente = ", cle_ok)
	# Un retour « faux » ne veut pas forcément dire que la bascule est cassée :
	# si une position partait en anglais parce que la traduction l'a manquée,
	# l'aller-retour la traduit et l'état final diffère de l'état initial. Le
	# symptôme est un trou de couverture, pas un défaut de F1 — on le distingue.
	if not retour_ok:
		print("SONDE retour != depart : comparer les comptes ci-dessus. Des")
		print("SONDE positions parties en anglais signalent une traduction manquante.")
	print("SONDE BILAN aller=%s retour=%s disques=%s cle=%s"
		% [str(ok), str(retour_ok), str(disques_ok), str(cle_ok)])
