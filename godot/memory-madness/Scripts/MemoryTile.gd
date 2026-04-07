class_name MemoryTile
extends TextureButton

@onready var frame: TextureRect = $Frame
@onready var item_image: TextureRect = $ItemImage

func setup(_image: Texture2D, _frame: Texture2D) -> void:
	frame.texture = _frame
	item_image.texture = _image


func reveal(should_reveal: bool = true) -> void:
	frame.visible = should_reveal
	item_image.visible = should_reveal


func _on_pressed() -> void:
	if !Scorer.SelectionEnabled:
		return
	reveal()
	SignalHub.emit_on_tile_selected(self)

func kill() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_property(self, "rotation_degrees", 720, 1.0)
	tween.tween_property(self, "scale", 1.5, 1.0)
	disabled = true

func matches(other_tile: MemoryTile) -> bool:
	return item_image.texture == other_tile.item_image.texture
