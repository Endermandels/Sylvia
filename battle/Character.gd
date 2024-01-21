extends Node2D

onready var sprite = $Sprite

"""
VERY USEFUL INFORMATION BELOW:
	to_local - converts global coordinates to local coordinates
"""

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Left mouse button is pressed
		var mouse_position = get_global_mouse_position()
		if sprite.get_rect().has_point(to_local(mouse_position)):
			# Player sprite is clicked
			print("Player sprite clicked!")

func _on_Space_move_player(new_position):
	sprite.global_position = new_position
