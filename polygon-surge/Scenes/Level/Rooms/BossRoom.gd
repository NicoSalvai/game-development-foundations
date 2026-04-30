class_name BossRoom
extends RoomBase

func start() -> void:
	entry_door.close()
	var orbis: Orbis = _find_orbis()
	if orbis == null:
		push_error("BossRoom: no se encontró Orbis en la escena.")
		return
	SignalHub.enemy_died.connect(_on_orbis_died)
	orbis.play_intro()


func _on_orbis_died() -> void:
	var orbis: Orbis = _find_orbis()
	if orbis == null || orbis._is_dead:
		room_cleared.emit()

func _find_orbis() -> Orbis:
	return get_tree().get_first_node_in_group("Orbis")
