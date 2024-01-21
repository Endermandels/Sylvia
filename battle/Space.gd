extends Area2D

onready var collision = $CollisionShape2D

signal move_player

func _on_Space_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Left mouse button is pressed
		print("Space clicked!")
		# Teleport selected player to space, if able
		emit_signal("move_player", collision.global_position)
