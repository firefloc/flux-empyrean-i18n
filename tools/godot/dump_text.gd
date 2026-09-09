# Sort toutes les chaines editables des scenes du jeu, indexees par
# (chemin de scene, index dans le tableau variants du PackedScene).
# C'est exactement l'adresse que patch_text.gd sait reecrire.
# GAME_EXE=<exe>  OUT_DIR=<dossier de travail>
extends SceneTree

const MIN_WORDS := 1

func walk(d: String, acc: Array) -> void:
	for f in DirAccess.get_files_at(d):
		acc.append(d.path_join(f))
	for sub in DirAccess.get_directories_at(d):
		walk(d.path_join(sub), acc)

func is_prose(s: String) -> bool:
	var t := s.strip_edges()
	if t.length() < 2 or t.begins_with("res://") or t.begins_with("uid://"):
		return false
	if t.contains("uniform ") or t.contains("void ") or t.begins_with("_"):
		return false
	# au moins une lettre et pas un identifiant snake_case brut
	return t.to_lower() != t.to_snake_case() or t.contains(" ")

func _init() -> void:
	var exe := OS.get_environment("GAME_EXE")
	var out := OS.get_environment("OUT_DIR")
	ProjectSettings.load_resource_pack(exe, true)
	var all := []
	walk("res://", all)
	var table := {}
	var count := 0
	for f in all:
		if not f.ends_with(".tscn.remap"):
			continue
		var scene_path: String = f.trim_suffix(".remap")
		var ps: PackedScene = ResourceLoader.load(scene_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if ps == null:
			continue
		var bundled: Dictionary = ps.get("_bundled")
		var variants: Array = bundled.get("variants", [])
		var entries := {}
		for i in variants.size():
			var v = variants[i]
			if v is String and is_prose(v):
				entries[str(i)] = v
				count += 1
		if not entries.is_empty():
			table[scene_path] = entries
	var fh := FileAccess.open(out.path_join("strings_scenes.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(table, "\t", false))
	fh.close()
	print("scenes avec texte: %d | chaines: %d" % [table.size(), count])
	quit()
