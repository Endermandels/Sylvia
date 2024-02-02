extends Area2D

@onready var collision = $CollisionShape2D

@export var grid_pos = [0,0]

@export var enemy_pos = [0,0]

signal move_player

func _on_Space_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Teleport selected player to space, if able
		emit_signal("move_player", collision.global_position, grid_pos)
