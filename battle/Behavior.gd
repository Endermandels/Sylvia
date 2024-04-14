extends Node

enum Behaviors {CAUTIOUS=0, NEUTRAL=1, VENGEFUL=2, AGGRESSIVE=3}

@onready var enemy = $".."
@onready var Behavior = pick_random_behavior()

# Picks a random behavior
func pick_random_behavior():
	return randi() % 4
	

	
	
# From a given turn list, choose what turn the enemy
# would make based on its behavior.
func choose_actions(enemy, turn_list, player_pos):
	if Behavior == Behaviors.CAUTIOUS:
		if enemy.stats.hp == enemy.stats.saved_hp:
			return choose_random_turn(turn_list)
		return cautious_turn(turn_list, player_pos)
	
	# A neutral behavior means the enemy makes turns randomly.
	if Behavior == Behaviors.NEUTRAL:
		return choose_random_turn(turn_list)
	
	# Vengeful enemies intially are neutral enemies until either an enemy dies
	# or they receive damage.
	if Behavior == Behaviors.VENGEFUL:
		var enemies = enemy.get_parent()
		for animal in enemies.get_children():
			if enemy.alive == false:
				return aggressive_turn(turn_list, player_pos)
		if enemy.stats.hp == enemy.stats.saved_hp:
			return choose_random_turn(turn_list)
		return aggressive_turn(turn_list, player_pos)
	
	# An aggressive enemy tries to get up close to the player and attack.	
	if Behavior == Behaviors.AGGRESSIVE:
		return aggressive_turn(turn_list, player_pos)

# Returns a random turn for a given turn list.			
func choose_random_turn(turn_list):
	return turn_list[randi() % len(turn_list)]

# Takes a list of turns and a list of all the playable characters postions
# and returns a list of cautious turns.
# A cautious turn is defined as a turn where the enemy can maximize the
# distance between the enemy and the playable characters.
func cautious_turn(turn_list, player_pos):
	var max_distance = 0
	var cautious_turns = []
	for turn in turn_list:
		for i in range(turn.size() - 1, -1, -1):
			var action = turn[i]
			if action.has("move"):
				# Assumes that the actual max distance between the enemy and
				# the player never exceeds 100.
				var max_turn_distance = 100
				for pos in player_pos:
					var distance = get_manhattan_distance(action[-1][0], pos)
					if distance < max_turn_distance: 
						max_turn_distance = distance
				if max_turn_distance > max_distance:
					max_distance = max_turn_distance
					cautious_turns.clear()
					cautious_turns.append(turn)
				elif max_turn_distance == max_distance:
					cautious_turns.append(turn)
				break
	return choose_random_turn(cautious_turns)

# Takes a list of turns and a list of player positions and
# returns an aggressive turn.
func aggressive_turn(turn_list, player_pos):
	var attack_turns = get_attack_turns(turn_list)
	if attack_turns.size() != 0:
		return choose_random_turn(attack_turns)
	return approach_player(turn_list, player_pos)

# Takes a list of turns and a list of player positions and
# returns a list of turns that best minimize the distance between
# the enemy and the player.
func approach_player(turn_list, player_pos):
	# Assumes that the actual max distance between the enemy and
	# the player never exceeds 100.
	var min_distance = 100
	var approach_turns = []
	for turn in turn_list:
		for i in range(turn.size() - 1, -1, -1):
			var action = turn[i]
			if action.has("move"):
				# Assumes that the actual max distance between the enemy and
				# the player never exceeds 100.
				var min_turn_distance = 100
				for pos in player_pos:
					var distance = get_manhattan_distance(action[-1][0], pos)
					if distance < min_turn_distance: 
						min_turn_distance = distance
				if min_turn_distance < min_distance:
					min_distance = min_turn_distance
					approach_turns.clear()
					approach_turns.append(turn)
				elif min_turn_distance == min_distance:
					approach_turns.append(turn)
				break
	return choose_random_turn(approach_turns)

# Takes a turn list and returns a list of turns
# that has attack as a action.
func get_attack_turns(turn_list):
	var attack_turns = []
	for turn in turn_list:
		for action in turn:
			if action.has("attack"):
				attack_turns.append(turn)
				break
	return attack_turns

# Returns the manhattan distance between two lists
# where each list contains two integers.
func get_manhattan_distance(pos1, pos2):
	return abs(pos1[0] - pos2[0]) + abs(pos1[1] - pos2[1])
