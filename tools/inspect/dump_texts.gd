extends SceneTree
func _init() -> void:
	ProjectSettings.load_resource_pack(OS.get_environment("GAME_EXE"), true)
	var s: GDScript = ResourceLoader.load("res://Scripts/texts.gd", "", ResourceLoader.CACHE_MODE_IGNORE)
	var inst = s.new()
	var data := {}
	for p in ["texts", "discoveries", "authors", "favorites"]:
		data[p] = inst.get(p)
	var texts: Dictionary = data["texts"]
	print("=== texts: ", texts.size(), " entrees")
	print("=== discoveries: ", (data["discoveries"] as Dictionary).size())
	print("=== authors: ", (data["authors"] as Dictionary).size())
	print("=== favorites: ", (data["favorites"] as Array).size())
	var words := 0
	for k in texts:
		words += str(texts[k]).split(" ", false).size()
	print("=== mots dans texts: ", words)
	print("=== 5 premieres cles: ", texts.keys().slice(0, 5))
	var out := OS.get_environment("OUT_DIR")
	var fh := FileAccess.open(out.path_join("texts_corpus.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(data, "\t", false))
	fh.close()
	if inst is Node: inst.free()
	quit()
