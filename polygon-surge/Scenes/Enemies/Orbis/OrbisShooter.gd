class_name OrbisShooter
extends Polygon2D


@onready var shooter_component: ShooterComponent = $ShooterComponent


func get_shooter() -> ShooterComponent:
	return shooter_component
