extends Node2D

@onready var sprite = $Sprite2D
@onready var stats = $Stats

var grid_rows = 5
var grid_cols = 7

var grid_pos = [3, 4]

"""
VERY USEFUL INFORMATION BELOW:
	to_local - converts global coordinates to local coordinates
"""

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Left mouse button is pressed
		var mouse_position = get_global_mouse_position()
		if sprite.get_rect().has_point(to_local(mouse_position)):
			# Player sprite is clicked
			print("Player sprite clicked!")

func move_to(start, target, moves_left, moved):
	if moves_left == 0:
		return false
	
	for col_offset in [-1, 1]:
		var adj_col = start[0] + col_offset
		var adj_row = start[1]
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			var new_space = [adj_col, adj_row]
			# Update moves left 
			if target == new_space:
				stats.move(moved)
				return true
			# Check adjacent squares
			if moves_left > 1 and move_to(new_space, target, moves_left-1, moved + 1):
				return true
	
	for row_offset in [-1, 1]:
		var adj_col = start[0]
		var adj_row = start[1] + row_offset
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			var new_space = [adj_col, adj_row]
			# Update moves left 
			if target == new_space:
				stats.move(moved)
				return true
			# Check adjacent squares
			if moves_left > 1 and move_to(new_space, target, moves_left-1, moved + 1):
				return true
	
	return false

func _on_Space_move_player(new_position, new_grid_pos):
	if move_to(grid_pos, new_grid_pos, stats.mov_left, 1):
		sprite.global_position = new_position
		grid_pos = new_grid_pos

func _on_battle_scene_players_turn():
	stats.reset()
