class_name Wizard


extends Node2D

signal cast_spell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reveal_timer_timeout() -> void:
	show()

func _on_spell_timer_timeout() -> void:
	print("done")
	cast_spell.emit()
	
func hitted() -> void:
	apply_scale(scale * 0.8)
