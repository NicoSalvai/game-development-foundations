extends Node

signal on_request_arrow(pos: Vector2, direction: Vector2, speed: float, type: Constants.ArrowType)
signal on_release_arrow(arrow: Arrow, type: Constants.ArrowType)
signal on_enemy_died
signal on_wave_completed
signal on_player_die
signal on_level_ended
signal on_create_arrow_impact(pos: Vector2)
signal on_create_enemy_death(pos: Vector2)
