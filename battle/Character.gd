"""
The Character handles:
	- Updating and remembering position
	- Updating and remembering stats
	- Collisions
"""

extends Node2D

@onready var sprite = $Sprite2D
@onready var stats = $Stats

var grid_rows = 5
var grid_cols = 7

var grid_pos = [3, 4]


"""
Recursively checks if the player can move to target space.
NOTE: Alters mov stat.
"""
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

"""
A Space is requesting to move the player to its position.
Check if the move is valid, and then move player's sprite and hitbox.
Returns success (true) or failure (false).
"""
func move_char(new_position, new_grid_pos):
	if move_to(grid_pos, new_grid_pos, stats.mov, 1):
		print('Mov left: ' + str(stats.mov))
		sprite.global_position = new_position
		grid_pos = new_grid_pos
		return true
	return false

func reset_stats():
	stats.reset()

func collect_food():
	stats.collect_morsel(1)

func use_action():
	stats.use_action()

func can_collect_food():
	return stats.can_collect_morsel()

func can_act():
	return stats.can_perform_act()
