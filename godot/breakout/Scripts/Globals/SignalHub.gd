extends Node

signal brick_died(points: int)
signal spawn_power_up(position: Vector2, power_up: BrickDefinition.PowerUp)
signal power_up_picked_up(power_up: BrickDefinition.PowerUp)
signal ball_died
signal won_game
signal lost_game
signal total_points_updated(total_points: int)
signal lives_updated(lives: int)
