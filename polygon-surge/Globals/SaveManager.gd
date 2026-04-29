extends Node

const SAVE_PATH := "user://save.json"


func save() -> void:
	var data := {
		"game_state": GameState.get_save_data(),
		"tech_tree": TechTreeState.get_save_data(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: no se pudo abrir el archivo para escribir: %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func load_save() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: no se pudo abrir el archivo para leer: %s" % SAVE_PATH)
		return
	var raw := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(raw)
	if parsed == null:
		push_error("SaveManager: el archivo de guardado está corrupto")
		return

	if parsed.has("game_state"):
		GameState.load_save_data(parsed["game_state"])
	if parsed.has("tech_tree"):
		TechTreeState.load_save_data(parsed["tech_tree"])


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
