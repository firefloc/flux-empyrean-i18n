# Reconstruit un .pck a partir du dossier extrait et du manifeste.
# OUT_DIR=<dossier de travail>
extends SceneTree

func _init() -> void:
	var out := OS.get_environment("OUT_DIR")
	var man := FileAccess.open(out.path_join("manifest.txt"), FileAccess.READ)
	if man == null:
		push_error("manifeste introuvable")
		quit(1)
		return
	var packer := PCKPacker.new()
	if packer.pck_start(out.path_join("repack.pck")) != OK:
		push_error("pck_start a echoue")
		quit(1)
		return
	var n := 0
	while not man.eof_reached():
		var line := man.get_line().strip_edges()
		if line.is_empty():
			continue
		var src := out.path_join("extract").path_join(line.trim_prefix("res://"))
		if not FileAccess.file_exists(src):
			push_warning("manquant: " + src)
			continue
		if packer.add_file(line, src) != OK:
			push_warning("ajout refuse: " + line)
			continue
		n += 1
	man.close()
	print("ajoutes: %d fichiers" % n)
	print("flush: %d" % packer.flush(false))
	quit()
