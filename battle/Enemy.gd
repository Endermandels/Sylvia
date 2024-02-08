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
	
	update_visual_position(enemy_pos)

	emit_signal("end_turn")
	
"""
Start is an array with two elements. The first element is the x
coordinate of the animal and the second element is the y coordinate.
Purpose of this function is to generate a list of all the possible
coordinates that the animal can move in a given turn.
"""
func generate_move_list(start, animal_speed : int):
	var row : int = start[0]
	var col : int = start[1]
	var x : int = -1 * animal_speed
	var y : int = 0
	var coordinates = Array()
	while(x <= animal_speed):
		var new_x : int = x + row
		if new_x >= 0 and new_x < grid_cols:
			for i in range(-y, y+1):
				var new_y : int = i + col
				if new_y >= 0 and new_y < grid_rows:
					coordinates.append([new_x, new_y])
		x += 1
		if x <= 0: y += 1
		else: y -= 1
	return coordinates

"""
new_pos is an array with two elements. The first element is the x
coordinate of the animal and the second element is the y coordinate.

This function gets the global location of the space node corresponding
to where we want the enemy to move so that we can update the enemy's position
visually.
"""
func update_visual_position(new_pos):
	# Gets the number corresponding to the specific space node that we
	# want to go to.
	var space_loc : int = enemy_pos[0] + 7 * enemy_pos[1]
	
	"""
	The space nodes can be found in the absolute path 
	"/root/BattleScene/Spaces" which we need to update the enemy's sprite.
	However the current path we are in is "/root/BattleScene/Characters/Enemy"
	therefore we need to change our path to access the space node.
	"""
	
	# Gets the battle_scene_node which its absolute path is 
	# "/root/BattleScene".
	var battle_scene_node : Node2D = get_parent().get_parent()
	
	# Gets the relative path "Spaces/SpaceN" where N is the number
	# corresponding to the specific Space node we want to got to.
	var space_path : String = "Spaces/Space" + str(space_loc)
	
	# Gets the location of the Space node which lives in the path
	# "/root/BattleScene/Spaces/SpaceN"
	var space_n_node = battle_scene_node.get_node("Spaces/Space" + str(space_loc))
	sprite.global_position = space_n_node.get_global_position()
