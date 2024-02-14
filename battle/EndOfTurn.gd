extends Node2D

@onready var sprite = $Sprite2D

signal end_turn

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = get_global_mouse_position()
		if sprite.get_rect().has_point(to_local(mouse_position)):
			emit_signal("end_turn")
