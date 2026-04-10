extends Node

signal on_create_bullet(pos: Vector2, direction: Vector2, speed: float, type: Constants.ObjectType)
signal on_create_object(pos: Vector2, type: Constants.ObjectType, points: int)
signal on_points_scored(points: int)
signal on_lives_change(shake: bool)
signal on_boss_killed
signal on_level_completed
signal on_game_over

func emit_on_create_bullet(pos: Vector2, direction: Vector2, speed: float, type: Constants.ObjectType) -> void:
	on_create_bullet.emit(pos, direction, speed, type)

func emit_on_create_explosion(pos: Vector2) -> void:
	on_create_object.emit(pos, Constants.ObjectType.EXPLOSION)

func emit_on_create_pickup(pos: Vector2, points: int) -> void:
	on_create_object.emit(pos, Constants.ObjectType.PICKUP, points)

func emit_on_points_scored(points: int) -> void:
	on_points_scored.emit(points)

func emit_on_lives_change(shake: bool) -> void:
	on_lives_change.emit(shake)

func emit_on_boss_killed() -> void:
	on_boss_killed.emit()

func emit_on_level_completed() -> void:
	on_level_completed.emit()

func emit_on_game_over() -> void:
	on_game_over.emit()
