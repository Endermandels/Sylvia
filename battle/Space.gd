extends Area2D

@export var grid_pos = [0,0]

var has_mouse = false

func _on_mouse_entered():
	has_mouse = true

func _on_mouse_exited():
	has_mouse = false
