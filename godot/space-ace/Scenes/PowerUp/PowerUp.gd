class_name PowerUp
extends Poolable

@onready var life_timer: Timer = $LifeTimer
@export var boost: int = 20.0

func activate() -> void:
	super()
	life_timer.start()


func _on_life_timer_timeout() -> void:
	deactivate()


func _on_detection_area_entered(area: Area2D) -> void:
	SignalHub.player_health_boost.emit(boost)
	deactivate()
