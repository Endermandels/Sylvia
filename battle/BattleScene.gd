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
@onready var enemies = $Enemies
@onready var food_counter = $FoodCounter

var gamestate = State.PLAYER_TURN
var actions_taken = []

# The various enemies and player characters are ordered by turn in this list
var battle_queue = [] # TODO: Implement

# Reference to the current character
var current_char = null

signal enemys_turn

"""
SETUP
"""

func _ready():
	set_process_input(true)
	hide_nodes()
	decide_turn_order()
	if Settings.keyboard_toggle:
		$UI/Control/QuitButton.grab_focus()
	players_turn()

func hide_nodes():
	collect_food_button.visible = false

"""
Decides using base movement speed of each unit in battle.
"""
func decide_turn_order():
	# TODO: Implement
	current_char = $"Characters/Clover"

"""
INPUT
"""

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		move_char()

"""
STATE CHANGE
"""

"""
When the player ends their turn, signal that it is the enemy's turn.
"""
func _on_end_of_turn_end_turn():
	if gamestate == State.PLAYER_TURN:
		gamestate = State.ENEMY_TURN
		emit_signal("enemys_turn")

"""
When the enemy ends their turn, signal that it is the player's turn.
"""
func _on_enemy_end_turn():
	if gamestate == State.ENEMY_TURN:
		gamestate = State.PLAYER_TURN
		actions_taken = []
		current_char.reset_stats()
		players_turn()

"""
Either enemy just ended their turn or player has used an action.
"""
func players_turn():
	collect_food_button.visible = false
	finish_movement_button.visible = false
	attack_button.visible = false
	
	if not current_char.can_act():
		return
	
	# Show Collect Food Button if:
	# player starts their turn on a food space
	# and they have room to collect more morsels
	if not 'collect_food' in actions_taken and current_char.can_collect_food():
		if get_food_under_character():
			collect_food_button.visible = true
	
	if not 'attack' in actions_taken and len(enemies_in_range(current_char.get_attack_range())) > 0:
		attack_button.visible = true


"""
FOOD
"""
# check if play is standing on a food space, return that food node
func get_food_under_character():
	for food in food_spaces.get_children():
		if food.grid_pos == current_char.grid_pos:
			return food
	return null
	

func _on_collect_food_button_pressed():
	current_char.collect_food()
	current_char.use_action()
	actions_taken.append('collect_food')
	get_food_under_character().queue_free() # make that food item disapear.
	food_counter.increment_count() # increment the food counter
	players_turn()

"""
MOVEMENT
"""

func _on_finish_movement_button_pressed():
	current_char.use_action()
	actions_taken.append('movement')
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
