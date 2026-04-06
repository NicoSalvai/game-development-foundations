class_name BrickGrid
extends Node2D

const MARGIN: float = 50.0
const GAP: float = 5.0
const BRICK_SIZE: Vector2 = Vector2(38.0, 12.0)
const BRICK = preload("uid://vsyohyh1ihtn")

@export var level_data: LevelData

func load_level(new_level_data: LevelData) -> int:
	level_data = new_level_data
	_clean_up()
	_self_position()
	var total_destructible_bricks: int = _load_bricks()
	return total_destructible_bricks


func _clean_up() -> void:
	for child in get_children():
		child.queue_free()


func _self_position() -> void:
	var total_width = ((level_data.columns - 1) * BRICK_SIZE.x) + ((level_data.columns - 1) * GAP)
	var screen_size = get_viewport_rect().size
	position = Vector2(
		(screen_size.x - total_width) / 2.0,
		MARGIN  # Y lo dejás con margen fijo arriba
	)


func _load_bricks() -> int:
	var total_destructible_bricks: int = 0
	for index in level_data.bricks.size():
		var col = index % level_data.columns
		var row = index / level_data.columns

		var brick_definition = level_data.bricks[index]
		if ! brick_definition:
			continue
		if ! brick_definition.is_unbreakable:
			total_destructible_bricks += 1
		var new_brick: Brick = _create_new_brick(brick_definition, col, row)
		add_child(new_brick)
	return total_destructible_bricks


func _create_new_brick(definition: BrickDefinition, col: int, row: int) -> Brick:
	var new_brick: Brick = BRICK.instantiate()
	new_brick.definition = definition
	new_brick.position = Vector2(_calculate_x(col), _calculate_y(row))
	return new_brick


func _calculate_x(col: int) -> float:
	return (col * (BRICK_SIZE.x + GAP))


func _calculate_y(row: int) -> float:
	return (row * (BRICK_SIZE.y + GAP))
