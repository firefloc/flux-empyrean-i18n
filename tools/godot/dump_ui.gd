# Relève les libellés courts d'interface que le premier passage avait filtrés :
# « Search... », « Clear », « Favorite », les onglets du journal, le bandeau du
# HUD. On ne garde que les variants réellement branchés sur une propriété
# d'affichage — le reste est de la donnée.
extends SceneTree

const AFFICHAGE := ["text", "placeholder_text", "tooltip_text", "hint_tooltip"]
const CLES := ["disc.tscn", "wimlock.tscn"]

func walk(d: String, acc: Array) -> void:
	for f in DirAccess.get_files_at(d): acc.append(d.path_join(f))
	for sub in DirAccess.get_directories_at(d): walk(d.path_join(sub), acc)

func _init() -> void:
	ProjectSettings.load_resource_pack(OS.get_environment("GAME_EXE"), true)
	var tout := []
	walk("res://", tout)
	var table := {}
	var n := 0
	for f in tout:
		if not f.ends_with(".tscn.remap"):
			continue
		var chemin: String = f.trim_suffix(".remap")
		var ps: PackedScene = ResourceLoader.load(chemin, "", ResourceLoader.CACHE_MODE_IGNORE)
		if ps == null:
			continue
		var etat := ps.get_state()
		var variants: Array = (ps.get("_bundled") as Dictionary)["variants"]
		var entrees := {}
		for noeud in etat.get_node_count():
			var type := etat.get_node_type(noeud)
			var instance := etat.get_node_instance(noeud)
			var chemin_instance := "" if instance == null else instance.resource_path
			for prop in etat.get_node_property_count(noeud):
				if not etat.get_node_property_name(noeud, prop) in AFFICHAGE:
					continue
				var valeur = etat.get_node_property_value(noeud, prop)
				if not valeur is String or valeur.strip_edges().is_empty():
					continue
				var cle := false
				for c in CLES:
					if c in chemin_instance:
						cle = true
				if cle:
					continue
				var i := variants.find(valeur)
				if i >= 0:
					entrees[str(i)] = valeur
					n += 1
		if not entrees.is_empty():
			table[chemin] = entrees
	var fh := FileAccess.open(OS.get_environment("OUT_DIR").path_join("strings_ui.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(table, "\t", false))
	fh.close()
	print("=== scenes: %d | libelles d'affichage: %d" % [table.size(), n])
	quit()
