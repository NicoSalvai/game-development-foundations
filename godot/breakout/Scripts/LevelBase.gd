class_name LevelBase
extends Node

const POWER_UP = preload("uid://bb4bx73glocut")
const PADDLE = preload("uid://cvstwnwbs75xl")
const BALL = preload("uid://dpwwvkfv48suw")
const BALL_Y_MARGIN: float = 30.0
const PADDLE_Y_MARGIN: float = 20.0

@onready var game_ui: GameUI = $CanvasLayer/GameUI
@onready var brick_grid: BrickGrid = $Container/BrickGrid
@onready var container: Node = $Container
var player_paddle: Paddle

var ball_counter: int = 0
var destructible_bricks_counter: int = 0
var total_points: int = 0
var lives: int = 3

func _ready() -> void:
	get_tree().paused = false
	game_ui.initialize(lives, total_points)
	SignalHub.ball_died.connect(_on_ball_died)
	SignalHub.brick_died.connect(_on_brick_died)
	SignalHub.spawn_power_up.connect(_on_spawn_power_up)
	SignalHub.power_up_picked_up.connect(_on_power_up_picked_up)
	_load_level_data()
	
	var viewport_x_mid = get_viewport().size.x / 2
	var viewport_y = get_viewport().size.y
	player_paddle = _spawn_paddle(viewport_x_mid, viewport_y)
	_spawn_ball(player_paddle)


func _load_level_data() -> void:
	var level_data = LevelLoader.load_level(GameManager.selected_level)
	if !level_data:
		# what to do?
		return
	destructible_bricks_counter = brick_grid.load_level(level_data)


func _spawn_ball(paddle: Paddle) -> void:
	var ball: Ball = _spawn_ball_position(Vector2(paddle.position.x, paddle.position.y - BALL_Y_MARGIN))
	ball.paddle = paddle


func _spawn_ball_position(position: Vector2) -> Ball:
	var ball: Ball = BALL.instantiate()
	ball.position = position
	container.add_child(ball)
	ball_counter += 1
	return  ball


func _spawn_paddle(x_start: int, y_start: int) -> Paddle:
	var paddle: Paddle = PADDLE.instantiate()
	paddle.position = Vector2(x_start, y_start - PADDLE_Y_MARGIN)
	container.add_child(paddle)
	return paddle


func _on_ball_died() -> void:
	ball_counter -= 1
	if ball_counter <= 0:
		lives -= 1
		SignalHub.lives_updated.emit(lives)
		if lives <= 0:
			SignalHub.lost_game.emit()
			get_tree().paused = true
		else:
			_spawn_ball(player_paddle)


func _on_brick_died(points: int) -> void:
	destructible_bricks_counter -= 1
	total_points += points 
	SignalHub.total_points_updated.emit(total_points)
	if destructible_bricks_counter == 0:
		SignalHub.won_game.emit()
		get_tree().paused = true


func _on_spawn_power_up(position: Vector2, power_up_type: BrickDefinition.PowerUp):
	var power_up: PowerUp = POWER_UP.instantiate()
	power_up.position = position
	power_up._power_up_type = power_up_type
	container.add_child(power_up)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if GameManager.game_state == GameManager.GameState.WON:
			GameManager.selected_level += 1
			GameManager.load_level_scene()
		if GameManager.game_state == GameManager.GameState.LOST:
			GameManager.load_level_scene()
	
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main_scene()


func _on_power_up_picked_up(power_up_type: BrickDefinition.PowerUp) -> void:
	var balls = get_tree().get_nodes_in_group(Ball.GROUP_NAME)
	for ball: Ball in balls:
		match power_up_type:
			BrickDefinition.PowerUp.MULTI_BALL:
				var new_ball: Ball = _spawn_ball_position(ball.position)
				new_ball.launch()
			BrickDefinition.PowerUp.STRONG_BALL:
				ball.damage += 1
