extends Node


signal on_animal_died
signal on_cup_destroyed
signal on_level_completed
signal on_attempts_updated(attempts: int)


func emit_on_animal_died() -> void:
	on_animal_died.emit()

func emit_on_cup_destroyed() -> void:
	on_cup_destroyed.emit()

func emit_level_completed() -> void:
	on_level_completed.emit()

func emit_attempts_updated(attempts: int) -> void:
	on_attempts_updated.emit(attempts)
