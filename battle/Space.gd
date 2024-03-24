extends Area2D

@export var grid_pos = [0,0]
@onready var character = $"../../Characters/Clover"
@onready var color_rect = $CollisionShape2D/ColorRect
@onready var battle_scene = $"../.."

var grid_rows = 5
var grid_cols = 7
var has_mouse = false
var lit = false


func _on_mouse_entered():
	has_mouse = true
	if lit:
		color_rect.modulate = Color(0.541, 0.83, 0.94, 1)


func _on_mouse_exited():
	has_mouse = false
	color_rect.modulate = Color(1, 1, 1, 1)

 
func _process(delta):
	var moves_left = character.get_node("Stats").mov
	var character_pos = character.grid_pos
	if can_move_to_character(character_pos, grid_pos, moves_left) and battle_scene.moving:
		color_rect.color.a = 0.3
		lit = true
	else:
		color_rect.color.a = 0
		lit = false


# This function checks if the character can move to the target position.
# It does not actually move the character.
func can_move_to_character(character_grid_pos, target_grid_pos, moves_left):
	return can_move_to(character_grid_pos, character_grid_pos, target_grid_pos, moves_left)

func can_move_to(origin, start, target, moves_left):
	if moves_left == 0:
		return false
	
	for col_offset in [-1, 1]:
		var adj_col = start[0] + col_offset
		var adj_row = start[1]
		if is_within_bounds(adj_col, adj_row):
			var new_space = [adj_col, adj_row]
			if new_space == target and new_space != origin:
				return true
			if moves_left > 1 and can_move_to(origin, new_space, target, moves_left - 1):
				return true
	
	for row_offset in [-1, 1]:
		var adj_col = start[0]
		var adj_row = start[1] + row_offset
		if is_within_bounds(adj_col, adj_row):
			var new_space = [adj_col, adj_row]
			if new_space == target and new_space != origin:
				return true
			if moves_left > 1 and can_move_to(origin, new_space, target, moves_left - 1):
				return true
	
	return false

# Helper function to check if a position is within grid bounds.
func is_within_bounds(col, row):
	return col >= 0 and col < grid_cols and row >= 0 and row < grid_rows
