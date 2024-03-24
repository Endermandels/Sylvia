"""
The Battle Scene handles:
	- Player inputs
	- Player state
	- Game State

NOTE:
	The collect food and finish movement buttons are only visible 
	when they are legal actions for the player to take.
"""

extends Node2D

# Keeps track of game states
enum State {
	PLAYER_TURN,
	ENEMY_TURN
}

@onready var collect_food_button = $UI/Control/CollectFoodButton
@onready var finish_movement_button = $UI/Control/FinishMovementButton
@onready var attack_button = $UI/Control/AttackButton

@onready var food_spaces = $FoodSpaces
@onready var spaces = $Spaces
@onready var cards = $BattleUI/Hand
@onready var enemies = $Enemies
@onready var food_counter = $FoodCounter
@onready var audio_manager = $AudioManager

var gamestate = State.PLAYER_TURN
var actions_taken = []

# The various enemies and player characters are ordered by turn in this list
var battle_queue = [] # TODO: Implement

# Names of all the enemies currently on the board.
var board_enemies = ["Jerry"]

# Enemies affected by character abilities or attacks
var affected_enemies = []
var affected_food = []

# Reference to the current character
var current_char = null

var moving = false

signal enemys_turn

"""
SETUP
"""

func _ready():
	audio_manager.playMusic("res://Music/battle_music (surf).ogg")
	set_process_input(true)
	hide_nodes()
	decide_turn_order()
	if Settings.keyboard_toggle:
		$UI/Control/QuitButton.grab_focus()
	current_char.save_stats()
	spawn_enemies(board_enemies, 7)
	players_turn()

func hide_nodes():
	collect_food_button.visible = false

"""
Decides using base movement speed of each unit in battle.
"""
func decide_turn_order():
	# TODO: Implement
	current_char = $"Characters/Clover"
	
func spawn_enemies(enemies_to_spawn, num_cols):
	for enemy_name in enemies_to_spawn:
		var enemy = enemies.get_node(enemy_name)
		enemy.enemy_pos = [randi() % num_cols, 0]
		enemy.update_visual_position((enemy.enemy_pos))

"""
INPUT
"""

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				move_char()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				for enemy in affected_enemies:
					enemy.stats.load_stats()
				
				for food in affected_food:
					food.load_stats()
					food_counter.decrement_count()
				
				current_char.load_stats()
				
				affected_enemies = []
				affected_food = []
				actions_taken = []
				moving = false
				
				players_turn()

"""
STATE CHANGE
"""

"""
When the player ends their turn, signal that it is the enemy's turn.
"""
func _on_end_of_turn_end_turn():
	if gamestate == State.PLAYER_TURN:
		audio_manager.playSFX("horn")
		gamestate = State.ENEMY_TURN
		emit_signal("enemys_turn")

"""
When the enemy ends their turn, signal that it is the player's turn.
"""
func _on_enemy_end_turn():
	if gamestate == State.ENEMY_TURN:
		gamestate = State.PLAYER_TURN
		
		for food in food_spaces.get_children():
			food.reset_saved_rand_space()
			food.save_stats()
		
		affected_enemies = []
		affected_food = []
		actions_taken = []
		
		current_char.reset_stats()
		current_char.save_stats()
		players_turn()

"""
Either enemy just ended their turn or player has used an action.
"""
func players_turn():
	
	if "movement" not in actions_taken:
		moving = true
		
	collect_food_button.visible = false
	finish_movement_button.visible = false
	attack_button.visible = false
	
	if not current_char.can_act():
		return
	
	# Show Collect Food Button if:
	# player starts their turn on a food space
	# and they have room to collect more morsels
	if not 'collect_food' in actions_taken and current_char.can_collect_food():
		if get_food(current_char.grid_pos):
			collect_food_button.visible = true
	
	if not 'attack' in actions_taken and len(enemies_in_range(current_char.get_attack_range())) > 0:
		attack_button.visible = true


"""
FOOD
"""
# check if play is standing on a food space, return that food node
func get_food(grid_pos):
	for food in food_spaces.get_children():
		if food.grid_pos == grid_pos:
			return food
	return null
	

func _on_collect_food_button_pressed():
	current_char.collect_food()
	current_char.use_action()
	actions_taken.append('collect_food')
	
	audio_manager.playSFX("eating")
	food_counter.increment_count()
	
	var food = get_food(current_char.grid_pos)
	food.save_stats()
	food.rand_pos(spaces)
	affected_food.append(food)
	
	players_turn()

"""
MOVEMENT
"""

func _on_finish_movement_button_pressed():
	current_char.use_action()
	actions_taken.append('movement')
	moving = false
	players_turn()

"""
Find the space with the mouse pointer in it.
Then try and move the player to that space.
Hide other action buttons if the player moves.
Show finish movement button if the player moves.
"""
func move_char():
	if gamestate == State.PLAYER_TURN and current_char.can_act() and not 'movement' in actions_taken:
		for space in spaces.get_children():
			if space.has_mouse:
				if current_char.move_char(space.global_position, space.grid_pos):
					# Need to remove other actions while moving
					collect_food_button.visible = false
					attack_button.visible = false
					finish_movement_button.visible = true
					moving = true

"""
ATTACK
"""

func _on_attack_button_pressed():
	print('attack')
	var choices = enemies_in_range(current_char.get_attack_range())
	var chosen_enemy = null
	
	if len(choices) > 1:
		#TODO: Implement Selection between multiple enemies
		pass
	else:
		chosen_enemy = choices[0]
		chosen_enemy.stats.save_stats()
		if not chosen_enemy in affected_enemies:
			affected_enemies.append(chosen_enemy)
	
	current_char.attack(chosen_enemy)
	current_char.use_action()
	actions_taken.append('attack')
	players_turn()

"""
Check if there is an enemy within a custom range of the current character.
The custom_range parameter is a list of coordinates from the current character's grid position.
(E.G. [[0,1],[0,-1],[1,0],[-1,0]])

Returns:
	in_range - which enemies are in range of attack (or ability).
	If in_range is null, there are no enemies in range.
"""
func enemies_in_range(custom_range):
	var in_range = []
	for enemy in enemies.get_children():
		for coord in custom_range:
			if enemy.enemy_pos[0] == coord[0] + current_char.grid_pos[0] and \
				enemy.enemy_pos[1] == coord[1] + current_char.grid_pos[1]:
				in_range.append(enemy)
				break
	return in_range

"""
Ability
"""

func _on_hand_play_card(card, targets):
	if not moving:
		if gamestate == State.PLAYER_TURN and current_char.can_act() and \
			not 'ability' in actions_taken:
			for enemy in enemies.get_children():
				# TODO: Affect multiple targets
				print(enemy.enemy_pos, targets[0].grid_pos)
				if enemy.enemy_pos[0] == targets[0].grid_pos[0] and \
					enemy.enemy_pos[1] == targets[0].grid_pos[1]:
					print('playing', card.stats.ability_name)
					
					if not enemy in affected_enemies:
						affected_enemies.append(enemy)
					
					card.stats.apply_effects(enemy)
					current_char.use_action()
					actions_taken.append('ability')
					players_turn()
					break
