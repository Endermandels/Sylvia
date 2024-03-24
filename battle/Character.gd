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
var saved_grid_pos = []

var affected_enemies = []

"""
Recursively checks if the character can move to target space from start.
Each level of recursion reduces moves_left and increases moved.
Origin refers to the character's space they occupied before moving.
Character should never land back at their origin space.
NOTE: Alters mov stat.
"""
func move_to(origin, start, target, moves_left, moved):
	if moves_left == 0:
		return false
	
	for col_offset in [-1, 1]:
		var adj_col = start[0] + col_offset
		var adj_row = start[1]
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			var new_space = [adj_col, adj_row]
			# Update moves left 
			if target == new_space && target != origin:
				stats.move(moved)
				return true
			# Check adjacent squares
			if moves_left > 1 and move_to(origin, new_space, target, moves_left-1, moved + 1):
				return true
	
	for row_offset in [-1, 1]:
		var adj_col = start[0]
		var adj_row = start[1] + row_offset
		
		# Check if the adjacent square is within the grid
		if adj_col >= 0 and adj_col < grid_cols and adj_row >= 0 and adj_row < grid_rows:
			var new_space = [adj_col, adj_row]
			# Update moves left 
			if target == new_space && target != origin:
				stats.move(moved)
				return true
			# Check adjacent squares
			if moves_left > 1 and move_to(origin, new_space, target, moves_left-1, moved + 1):
				return true
	
	return false

"""
A Space is requesting to move the player to its position.
Check if the move is valid, and then move player's sprite and hitbox.
Returns success (true) or failure (false).
"""
func move_char(new_position, new_grid_pos):
	if move_to(grid_pos, grid_pos, new_grid_pos, stats.mov, 1):
		print('Mov left: ' + str(stats.mov))
		sprite.global_position = new_position
		grid_pos = new_grid_pos.duplicate()
		
		return true
	return false

func attack(enemy):
	print(enemy.name + " attacked for " + str(stats.atk))
	enemy.stats.receiveDMG(stats.atk)
	print(enemy.name + " remaining HP " + str(enemy.stats.hp))

func save_stats():
	stats.save_stats()
	saved_grid_pos = [sprite.global_position, grid_pos]

"""
Load character's stats and enemies stats to before combat
"""
func load_stats():
	stats.load_stats()
	grid_pos = saved_grid_pos[1].duplicate()
	sprite.global_position = saved_grid_pos[0]

func reset_stats():
	stats.reset()

func collect_food():
	stats.collect_morsel(1)

func use_action():
	stats.use_action()

func get_attack_range():
	return stats.get_attack_range()

func can_collect_food():
	return stats.can_collect_morsel()

func can_act():
	return stats.can_perform_act()
