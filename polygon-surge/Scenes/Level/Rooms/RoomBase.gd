class_name RoomBase
extends Node2D

signal room_cleared

@onready var room_manager: RoomManager = $RoomManager
@onready var entry_door: Door = $EntryDoor
@onready var exit_door: Door = $ExitDoor


func start() -> void:
	entry_door.close()
	room_manager.room_cleared.connect(_on_room_cleared)
	room_manager.start()


func _on_room_cleared() -> void:
	room_cleared.emit()
