# Recense les chaines qui servent de reponse a une enigme : proprietes
# answer / answers / display_text posees dans les scenes, avec l'index du
# variant correspondant dans strings_scenes.json.
# GAME_EXE=<exe>  OUT_DIR=<dossier de travail>
extends SceneTree

const LOCKED_PROPS := ["answer", "answers", "code", "solution", "password"]

func walk(d: String, acc: Array) -> void:
	for f in DirAccess.get_files_at(d):
		acc.append(d.path_join(f))
	for sub in DirAccess.get_directories_at(d):
		walk(d.path_join(sub), acc)

func _init() -> void:
	ProjectSettings.load_resource_pack(OS.get_environment("GAME_EXE"), true)
	var all := []
	walk("res://", all)
	var locks := {}
	for f in all:
		if not f.ends_with(".tscn.remap"):
			continue
		var scene_path: String = f.trim_suffix(".remap")
		var ps: PackedScene = ResourceLoader.load(scene_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if ps == null:
			continue
		var state := ps.get_state()
		var variants: Array = (ps.get("_bundled") as Dictionary)["variants"]
		var found := []
		for n in state.get_node_count():
			for p in state.get_node_property_count(n):
				if not state.get_node_property_name(n, p) in LOCKED_PROPS:
					continue
				var value = state.get_node_property_value(n, p)
				for value_str in (value if value is Array else [value]):
					if not value_str is String or value_str.is_empty():
						continue
					found.append({
						"node": state.get_node_name(n),
						"prop": state.get_node_property_name(n, p),
						"value": value_str,
						"variant": variants.find(value_str),
					})
		if not found.is_empty():
			locks[scene_path] = found
	var fh := FileAccess.open(OS.get_environment("OUT_DIR").path_join("puzzle_locks.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(locks, "\t", false))
	fh.close()
	print("scenes verrouillees: %d" % locks.size())
	quit()
