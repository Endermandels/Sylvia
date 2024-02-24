extends Node2D

@export var grid_pos = [2, 2]

# TODO: Respawn Food at a random location after collecting a morsel.
func set_grid_pos(x, y):
	grid_pos = [x, y]
