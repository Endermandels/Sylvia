extends Node2D

var enemy_speed = 2
@onready var sprite = $Sprite2D

var grid_rows = 5
var grid_cols = 7
var enemy_pos = [3, 0]

signal end_turn

func _on_battle_scene_enemys_turn():
	var possible_positions = generate_move_list(enemy_pos, enemy_speed)
	print("All the possible positions for the enemy are: ")
	print(possible_positions)
	var new_position = possible_positions[randi() % len(possible_positions)]
	enemy_pos = new_position
	print("Moved to: ", new_position)
	print()
	
	# Purpose of below lines is to update the global coordinates for the visual
	# sprite.
	var new_pos := Vector2(218 + new_position[0] * 60, 67 + new_position[1] * 60)
	sprite.global_position = new_pos
	
	emit_signal("end_turn")

# Start is an array with two elements. The first element is the x
# coordinate of the animal and the second element is the y coordinate.
# Purpose of this function is to generate a list of all the possible
# coordinates that the animal can move in a given turn.
func generate_move_list(start, animal_speed : int):
	var row : int = start[0]
	var col : int = start[1]
	var x : int = -1 * animal_speed
	var y : int = 0
	var coordinates = Array()
	while(x <= animal_speed):
		var new_x = x + row
		if new_x >= 0 and new_x < grid_cols:
			for i in range(-y, y+1):
				var new_y = i + col
				if new_y >= 0 and new_y < grid_rows:
					coordinates.append([new_x, new_y])
		x += 1
		if x <= 0: y += 1
		else: y -= 1
	return coordinates
