# Pour chaque scene, associe chaque index de variant aux (chemin de noeud,
# type, script, propriete) qui l'utilisent. Permet de distinguer une chaine
# affichee d'une cle de dictionnaire (Disc.text -> Texts.texts[text]).
# GAME_EXE=<exe>  OUT_DIR=<dossier de travail>
extends SceneTree

func walk(d: String, acc: Array) -> void:
	for f in DirAccess.get_files_at(d):
		acc.append(d.path_join(f))
	for sub in DirAccess.get_directories_at(d):
		walk(d.path_join(sub), acc)

func _init() -> void:
	var exe := OS.get_environment("GAME_EXE")
	var out := OS.get_environment("OUT_DIR")
	ProjectSettings.load_resource_pack(exe, true)
	var all := []
	walk("res://", all)
	var table := {}
	for f in all:
		if not f.ends_with(".tscn.remap"):
			continue
		var scene_path: String = f.trim_suffix(".remap")
		var ps: PackedScene = ResourceLoader.load(scene_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if ps == null:
			continue
		var bundled: Dictionary = ps.get("_bundled")
		var variants: Array = bundled.get("variants", [])
		# valeur String -> index (les variants sont dedupliques)
		var by_value := {}
		for i in variants.size():
			var v = variants[i]
			if v is String:
				if not by_value.has(v):
					by_value[v] = str(i)
		var st: SceneState = ps.get_state()
		var entries := {}
		# 1er passage: relever le script de chaque noeud
		var scripts := {}
		for n in st.get_node_count():
			for p in st.get_node_property_count(n):
				if st.get_node_property_name(n, p) == "script":
					var sc = st.get_node_property_value(n, p)
					if sc != null and sc is Resource:
						scripts[n] = str(sc.resource_path)
		for n in st.get_node_count():
			var npath := str(st.get_node_path(n))
			var ntype := str(st.get_node_type(n))
			var inst = st.get_node_instance(n)
			if inst != null:
				ntype = "instance:" + str(inst.resource_path)
			var nscript: String = scripts.get(n, "")
			for p in st.get_node_property_count(n):
				var pname := str(st.get_node_property_name(n, p))
				var val = st.get_node_property_value(n, p)
				if not (val is String):
					continue
				if not by_value.has(val):
					continue
				var idx: String = by_value[val]
				if not entries.has(idx):
					entries[idx] = []
				entries[idx].append({
					"node": npath, "type": ntype,
					"script": nscript, "prop": pname,
				})
		if not entries.is_empty():
			table[scene_path] = entries
	var fh := FileAccess.open(out.path_join("scene_prop_map.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(table, "\t", false))
	fh.close()
	print("scenes mappees: %d" % table.size())
	quit()
