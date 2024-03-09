extends "res://addons/gut/test.gd"

@onready var char_scene = preload("res://battle/Character.tscn")
@onready var enemy_scene = preload("res://battle/Enemy.tscn")

var cannot_move_to_params = [
	[
		[[3,2], [3,2], 0, 1]
	],
	[
		[[3,2], [3,3], 0, 1]
	],
	[
		[[3,2], [3,2], 1, 1]
	],
	[
		[[3,2], [5,2], 1, 1]
	],
	[
		[[3,2], [3,4], 1, 1]
	],
	[
		[[3,2], [1,2], 1, 1]
	],
	[
		[[3,2], [3,0], 1, 1]
	],
	[
		[[3,2], [2,3], 1, 1]
	],
	[
		[[3,2], [4,3], 1, 1]
	],
	[
		[[3,2], [2,1], 1, 1]
	],
	[
		[[3,2], [4,1], 1, 1]
	],
	[
		[[0,0], [-1,0], 1, 1]
	],
	[
		[[0,0], [0,-1], 1, 1]
	],
	[
		[[6,4], [6,5], 1, 1]
	],
	[
		[[6,4], [7,4], 1, 1]
	],
	[
		[[3,2], [3,2], 2, 1]
	],
	[
		[[3,2], [6,2], 2, 1]
	],
	[
		[[3,2], [0,2], 2, 1]
	],
	[
		[[3,2], [2,0], 2, 1]
	],
	[
		[[3,2], [4,4], 2, 1]
	]
]

var can_move_char_params = [
	[
		[4,3]
	],
	[
		[4,4]
	],
	[
		[4,1]
	],
	[
		[4,0]
	],
	[
		[3,2]
	],
	[
		[2,2]
	],
	[
		[5,2]
	],
	[
		[6,2]
	],
	[
		[3,3]
	],
	[
		[3,1]
	],
	[
		[5,3]
	],
	[
		[5,1]
	]
]

# Acceptance Tests (20 tests)
func test_char_cannot_move_to(params=use_parameters(cannot_move_to_params)):
	var mychar = char_scene.instantiate()
	add_child(mychar)
	
	var this_params = params[0]
	var result = mychar.move_to(this_params[0], this_params[1], this_params[2], this_params[3])
	assert_eq(result, false, "Character should not be able to move from " + str(this_params[0]) + 
		" to " + str(this_params[1]))
		
	mychar.queue_free()

# Acceptance Tests (12 tests)
func test_char_can_move_char(params=use_parameters(can_move_char_params)):
	var mychar = char_scene.instantiate()
	add_child(mychar)
	mychar.grid_pos = [4,2] # Middle of Battle Grid
	
	var new_grid_pos = params[0]
	var result = mychar.move_char(Vector2.ZERO, new_grid_pos)
	assert_eq(result, true, "Character should by able to move from " + str(mychar.grid_pos) +
		" to " + str(new_grid_pos))
	
	mychar.queue_free()

# White-box Test
# Statement coverage
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
func test_statement_coverage_move_to():
	var mychar = char_scene.instantiate()
	add_child(mychar)
	
	# Covers first if statement
	var result = mychar.move_to([4,2], [4,3], 0, 1)
	assert_eq(result, false, "Character should not be able to move with 0 movement")
	
	# Covers first for loop (x)
	result = mychar.move_to([4,2], [2,2], 2, 1)
	assert_eq(result, true, "Character should be able to move from [4, 2] to [2, 2] with 2 movement")
	
	# Covers second for loop (y)
	result = mychar.move_to([4,2], [4,4], 2, 1)
	assert_eq(result, true, "Character should be able to move from [4, 2] to [4, 4] with 2 movement")
	
	# Covers return false at end of function
	result = mychar.move_to([4,2], [3,4], 2, 1)
	assert_eq(result, false, "Character should not be able to move from [4, 2] to [3, 4] with 2 movement")
	
	mychar.queue_free()

# Integration Test
# Testing Character and Enemy units
# Bottom-Up approach
func test_attack():
	var mychar = char_scene.instantiate()
	var myenemy = enemy_scene.instantiate()
	add_child(mychar)
	add_child(myenemy)
	
	myenemy.stats.hp = 3
	mychar.stats.atk = 2
	
	mychar.attack(myenemy)
	assert_eq(myenemy.stats.hp, 1, "Enemy's HP should be 1 after the player attacks for 2")
	
	mychar.queue_free()
	myenemy.queue_free()

