extends Node2D


const BALL = preload("uid://dekvrk3q3we2k")
const PADDLE = preload("uid://tcjanskcdbc8")

@export var max_initial_ball_speed: float = 750.0
@export var initial_ball_speed: float = 250.0
@export var ball_speed_increment: float = 50.0
@export var ball_speed_increment_on_hit: float = 25.0
@export var score_goal: int = 5

@onready var game_ui: GameUi = $CanvasLayer/GameUI
@onready var container: Node = $Container
@onready var player_1_spawn_point: Marker2D = $Container/Player1SpawnPoint
@onready var player_2_spawn_point: Marker2D = $Container/Player2SpawnPoint


var players: Dictionary = {
		"player1": {
			"id": 1,
			"name": "Player1",
			"spawn_point": null,
			"paddle": null,
			"flip": true,
			"up_input": "ui_up_2",
			"down_input": "ui_down_2"
		},
		"player2": {
			"id": 2,
			"name": "Player2",
			"spawn_point": null,
			"paddle": null,
			"flip": false,
			"up_input": "ui_up",
			"down_input": "ui_down"
		}
	}


func _ready() -> void:
	game_ui.score_goal = score_goal
	game_ui.start_match.connect(_start_match)
	players.player1.spawn_point = player_1_spawn_point
	players.player2.spawn_point = player_2_spawn_point
	_create_paddle(players.player1)
	_create_paddle(players.player2)
	get_tree().paused = true


func _create_paddle(player: Dictionary) -> void:
	var paddle: Paddle = PADDLE.instantiate()
	container.add_child(paddle)
	paddle.setup(player.flip, player.spawn_point.position, player.up_input, player.down_input)
	player.paddle = paddle


func _create_new_ball() -> Ball:
	var ball: Ball = BALL.instantiate()
	ball.speed_increment_on_hit = ball_speed_increment_on_hit
	ball.position = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y / 2)
	ball.ball_exited_screen.connect(_on_ball_exited_screen)
	return ball


func _launch_ball(ball: Ball) -> void:
	container.add_child(ball)
	ball.launch(initial_ball_speed, _get_random_direction())


func _get_random_direction() -> Vector2:
	var direction = 1.0 if randf() > 0.5 else -1.0
	var angle = randf_range(-0.5, 0.5) # en radianes (~ -30° a 30°)
	return Vector2(direction, sin(angle)).normalized()


func _start_match() -> void:
	get_tree().paused = false
	var ball: Ball = _create_new_ball()
	_launch_ball(ball)


func _on_ball_exited_screen(direction: float) -> void:
	get_tree().paused = true
	var scoring_player_id: int = players.player1.id if direction > 0 else players.player2.id
	SignalBusI.emit_point_scored(scoring_player_id)
	_update_initial_ball_speed()
	_reset_paddles()


func _update_initial_ball_speed() -> void:
	initial_ball_speed = min(initial_ball_speed + ball_speed_increment, max_initial_ball_speed)


func _reset_paddles() -> void:
	for player in players.values():
		player.paddle.position = player.spawn_point.position
