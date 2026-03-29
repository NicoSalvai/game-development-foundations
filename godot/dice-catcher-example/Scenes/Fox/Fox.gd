extends Area2D


class_name Fox


signal scored


@onready var fox: Sprite2D = $Fox
@onready var eating_sound: AudioStreamPlayer2D = $EatingSound
@export var speed: float = 300.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	movement(delta)

	
func movement(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	if !is_zero_approx(direction):
		fox.flip_h = direction > 0
	
	move_local_x(delta * speed * direction)
 

func _on_area_entered(area: Area2D) -> void:
	if area is Dice:
		eating_sound.play()
		area.queue_free()
		scored.emit()
