# Le jeu peut-il fabriquer lui-même ses scènes traduites ?
#
# Enjeu : les 205 libellés d'interface passent aujourd'hui par 5,9 Mo de `.scn`
# réécrits hors ligne avec Godot. Ce sont des copies des fichiers de ChillCash
# — on ne peut donc ni les distribuer, ni demander à un joueur d'installer
# Godot pour les produire.
#
# S'il existe une troisième voie, c'est celle-ci : le jeu **est** un moteur
# Godot. Au premier lancement, il charge chaque scène, mute `_bundled.variants`
# et l'écrit sur le disque du joueur avec `ResourceSaver`. Les lancements
# suivants lisent ces fichiers, et on retrouve les 180/205 des `.scn` hors ligne
# au lieu des 65/205 de la mutation à chaud. Rien n'est distribué, et tout se
# régénère à chaque mise à jour du jeu.
#
# Ce test répond à trois questions, dans l'ordre où elles peuvent échouer :
#   1. `ResourceSaver.save()` accepte-t-il un chemin hors `res://` ?
#   2. le fichier écrit est-il relisible, et porte-t-il la traduction ?
#   3. sa taille reste-t-elle du même ordre que l'original ?
#
# GAME_EXE=<exe> SORTIE=<dossier> godot --headless --path tools/godot -s test_resourcesaver.gd
extends SceneTree


func _init() -> void:
	ProjectSettings.load_resource_pack(OS.get_environment("GAME_EXE"), true)
	var sortie := OS.get_environment("SORTIE")
	DirAccess.make_dir_recursive_absolute(sortie)

	var chemin := "res://FluxGame/MainMenu/main_menu.tscn"
	var scene: PackedScene = ResourceLoader.load(chemin, "", ResourceLoader.CACHE_MODE_REPLACE)
	var bundled: Dictionary = scene.get("_bundled")
	var variants: Array = bundled["variants"]

	var cible := -1
	for i in variants.size():
		if variants[i] is String and (variants[i] as String).length() > 2:
			cible = i
			break
	if cible < 0:
		print("RESULTAT aucune chaine a muter")
		quit(2)
		return

	var avant: String = variants[cible]
	var apres := "SENTINELLE"
	variants[cible] = apres
	bundled["variants"] = variants
	scene.set("_bundled", bundled)

	# 1. Écriture hors de res://, comme le ferait le mod chez le joueur.
	var fichier := sortie + "/essai.scn"
	var code := ResourceSaver.save(scene, fichier)
	print("ecriture : %s (code %d)" % [fichier, code])
	if code != OK:
		print("RESULTAT ResourceSaver refuse ce chemin : NON VIABLE")
		quit(1)
		return

	# 2. Relecture indépendante.
	var relu: PackedScene = ResourceLoader.load(fichier, "", ResourceLoader.CACHE_MODE_IGNORE)
	if relu == null:
		print("RESULTAT fichier ecrit mais illisible : NON VIABLE")
		quit(1)
		return
	var relu_variants: Array = (relu.get("_bundled") as Dictionary)["variants"]
	var conserve: bool = relu_variants[cible] == apres
	print("traduction conservee apres relecture : ", conserve)

	# 3. Et l'instanciation la voit-elle ?
	var racine := relu.instantiate()
	var vu := false
	var pile: Array[Node] = [racine]
	while not pile.is_empty():
		var n: Node = pile.pop_back()
		if "text" in n and n.get("text") == apres:
			vu = true
		for e in n.get_children():
			pile.append(e)
	racine.free()
	print("visible dans l arbre instancie : ", vu)
	print("taille ecrite : %d octets (chaine remplacee : %s -> %s)"
		% [FileAccess.get_file_as_bytes(fichier).size(), avant, apres])

	print("RESULTAT ", "generation par le jeu VIABLE" if (conserve and vu) else "NON VIABLE")
	quit(0 if (conserve and vu) else 1)
