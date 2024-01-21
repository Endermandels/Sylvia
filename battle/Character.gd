extends Node2D

onready var sprite = $Sprite
onready var stats = $Stats

var grid_rows = 5
var grid_cols = 7

var grid_pos = [3, 4]
var possible_moves = []

"""
VERY USEFUL INFORMATION BELOW:
	to_local - converts global coordinates to local coordinates
"""

func _ready():
	possible_moves = update_possible_moves(grid_pos, stats.mov)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Left mouse button is pressed
		var mouse_position = get_global_mouse_position()
		if sprite.get_rect().has_point(to_local(mouse_position)):
			# Player sprite is clicked
			print("Player sprite clicked!")

func update_possible_moves(start, moves_left):
	if moves_left == 0:
		return [start]
	
	var moves = []
	
	for col_offset in [-1, 0, 1]:
		var adj_col = start[0] + col_offset
		var adj_row = start[1]
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			for space in update_possible_moves([adj_col, adj_row], moves_left-1):
				if not space in moves:
					moves.append(space)
	
	for row_offset in [-1, 0, 1]:
		var adj_col = start[0]
		var adj_row = start[1] + row_offset
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			for space in update_possible_moves([adj_col, adj_row], moves_left-1):
				if not space in moves:
					moves.append(space)
	
	return moves

func can_move_to_grid_pos(new_grid_pos):
	return new_grid_pos in possible_moves

func _on_Space_move_player(new_position, new_grid_pos):
	if can_move_to_grid_pos(new_grid_pos):
		sprite.global_position = new_position
		grid_pos = new_grid_pos
		possible_moves = update_possible_moves(grid_pos, stats.mov)
