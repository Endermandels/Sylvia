extends Node2D

@onready var sprite = $Sprite2D
@onready var stats = $Stats
@onready var hitbox = $Area2D

#temp way to get the player
@onready var clover = get_parent().get_parent().get_node("Characters/Clover")


var grid_rows = 5
var grid_cols = 7
var enemy_pos = [3, 0]

signal end_turn
	
func attacked_for(damage):
	print('Enemy attacked for ' + str(damage))
	stats.receiveDMG(damage)
	print('Enemy remaining HP ' + str(stats.hp))

func _on_battle_scene_enemys_turn():
	var possible_actions = [["generate_move_list", true, true],
	["generate_attack_list", true, false]]
	var turn_list = generate_turn_list(possible_actions, enemy_pos,
	stats.mov, stats.act)
	print("All the actions for the enemy are: ")
	for turn in turn_list:
		print(turn)
	var next_turn = turn_list[randi() % len(turn_list)]
	print("Next turn will be: ")
	print(next_turn)
	for action in next_turn:
		callv(action[0], action[1])
	
	emit_signal("end_turn")

"""
Generates all the possible actions that a given animal can do for its turn.
This function has 4 parameters.

The purpose of the first parameter is to indicate what the possible
actions are for a given animal and to generate the possible outcomes for
doing any given action. The first parameter is an array of arrays in which each
the sub-array(s) contains three elements. 
The first element is the string of the function that generates all the possible 
outcomes for performing a given action (ex. moving or attacking some animal). 
The rest of the parameters are boolean values that indicate if you need to
pass a given stat to the function given in the first parameter.
The second parameter determines if you need to pass the position of the animal
and the third parameter determines if you need to pass the speed of the animal.

The second parameter is the position of the animal.

The third parameter is the speed of the animal.

The fourth parameter is the number of actions that an animal can make in a 
given turn.

This function returns an array of possible turns that the animal can make.
Each turn is represented by an array that contains the function(s) names 
necessary to perform the action(s) along with the necessary
parameters that they would need.
"""
func generate_turn_list(possible_actions, pos, speed, num_actions):
	if num_actions == 0: return []
	var turn_list = []
	var char_stats = [pos, speed]
	for action in possible_actions:
		var action_args = []
		
		# Below for loop puts the necessary arguments needed
		# for the function given in action[0].
		for i in range(len(char_stats)):
			if action[i+1]: 
				action_args.append(char_stats[i])
		
		# callv first parameter is a string used to call the corresponding 
		# function. 
		# The second parameter is an array of argument(s) that need to be passed
		# to the function defined by the first parameter.
		var new_actions = callv(action[0], action_args)
		if new_actions == null: continue
		var next_possible_actions = possible_actions.duplicate(true)
		next_possible_actions.remove_at(next_possible_actions.find(action))
		if len(next_possible_actions) == 0: 
			turn_list.append(new_actions)
			continue
			
		for next_action in next_possible_actions:
			var original_pos = pos
			for possible_action in new_actions:
				
				# The move function requires the animal to change position
				# which we need to consider for the following actions in a
				# given turn.
				if possible_action[0] == "move":
					pos = possible_action[1][0]
					
				var possible_next_actions = generate_turn_list(
				next_possible_actions, pos, speed, num_actions - 1)

				if possible_next_actions != []:
					for new_action in possible_next_actions[0]:
						turn_list += [[possible_action] + [new_action]]
				pos = original_pos
		for turn in new_actions:
			turn_list.append([turn])
	return turn_list
	
"""
Start is an array with two elements. The first element is the x
coordinate of the animal and the second element is the y coordinate.

Purpose of this function is to generate an array of all the possible
coordinates that the animal can move in a given turn.

Each element of the array is an array that contains two elements.
The first element is the string "move" and the second element is a
coordinate that the animal can move to which is the argument
that would be passed when calling the move function.
"""
# TODO: Make it so that an animal can not move to a space that is already
# occupied.
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
					coordinates.append(["move", [[new_x, new_y]]])
		x += 1
		if x <= 0: y += 1
		else: y -= 1
	return coordinates

"""
Moves the enemy to the given coordinates and visually
updates their position.
"""
func move(coordinates):
	enemy_pos = coordinates
	print("Moved to: ", enemy_pos)
	print()
	update_visual_position(enemy_pos)

"""
Currently determines if enemy can attack player and if true then return
an array of two elements. The first element is the string "attack" which
corresponds with the function attack and the second element is an array of
the arguments needed for the function attack which is the amount of damage
the attack will do.
"""
func generate_attack_list(pos):
	# TODO: Make function generalizable for a board with more than
	# two animals and for animals that are not the enemy.
	
	# Temporary way of getting player's position.
	var clover_pos = clover.grid_pos
	for i in range(len(pos)):
		# Attack range is currently one tile.
		for j in [-1, 1]:
			var attack_pos = pos.duplicate(false)
			attack_pos[i] = pos[i] + j
			if attack_pos == clover_pos:
				
				return [["attack", [stats.atk]]]

# Attacks the player
func attack(damage):
	#temp way getting the characters stats
	var clover_stats = clover.get_node("Stats")
	print('Player attacked for ' + str(damage))
	clover_stats.receiveDMG(stats.atk)
	print('Player remaining HP ' + str(clover_stats.hp))
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
	var space_loc : int = new_pos[0] + 7 * new_pos[1]
	
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
	var space_n_node = battle_scene_node.get_node(space_path)
	sprite.global_position = space_n_node.get_global_position()
	hitbox.global_position = sprite.global_position
