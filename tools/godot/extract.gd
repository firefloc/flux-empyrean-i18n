# Extrait tous les fichiers du pack embarque dans l'exe du jeu.
# GAME_EXE=<chemin exe>  OUT_DIR=<dossier de sortie>
extends SceneTree

func walk(d: String, acc: Array) -> void:
	for f in DirAccess.get_files_at(d):
		acc.append(d.path_join(f))
	for sub in DirAccess.get_directories_at(d):
		walk(d.path_join(sub), acc)

func _init() -> void:
	var exe := OS.get_environment("GAME_EXE")
	var out := OS.get_environment("OUT_DIR")
	if not ProjectSettings.load_resource_pack(exe, true):
		push_error("pack illisible: " + exe)
		quit(1)
		return
	var all := []
	walk("res://", all)
	var manifest := FileAccess.open(out.path_join("manifest.txt"), FileAccess.WRITE)
	var n := 0
	for f in all:
		# ecarte les scripts du projet sonde, qui vivent aussi sous res://
		if f.get_base_dir() == "res://" and (f.ends_with(".gd") or f == "res://project.godot"):
			continue
		var src := FileAccess.open(f, FileAccess.READ)
		if src == null:
			continue
		var buf := src.get_buffer(src.get_length())
		src.close()
		var dst := out.path_join("extract").path_join(f.trim_prefix("res://"))
		DirAccess.make_dir_recursive_absolute(dst.get_base_dir())
		var o := FileAccess.open(dst, FileAccess.WRITE)
		if o == null:
			continue
		o.store_buffer(buf)
		o.close()
		manifest.store_line(f)
		n += 1
	manifest.close()
	print("extraits: %d fichiers" % n)
	quit()
