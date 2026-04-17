class_name Constants

const PLAYER_GROUP: String = "Player"

static func set_timer(timer: Timer, target: float, variance: float = 0.0) -> void:
	timer.start(target + randf_range(-variance, variance))
