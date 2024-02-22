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

@onready var collect_food_button = $CollectFoodButton
@onready var finish_movement_button = $FinishMovementButton

@onready var food_spaces = $FoodSpaces
@onready var spaces = $Spaces

var gamestate = State.PLAYER_TURN
var actions_taken = []

# The various enemies and player characters are ordered by turn in this list
var battle_queue = [] # TODO: Implement

# Reference to the current character
var current_char = null

# Stop all player actions until the player has made a decision
var is_making_decision = false

signal enemys_turn

"""
SETUP
"""

func _ready():
	set_process_input(true)
	hide_nodes()
	decide_turn_order()
	if Settings.keyboard_toggle:
		$UI/Control/Quit.grab_focus()
		

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
	if not current_char.can_act():
		collect_food_button.visible = false
		finish_movement_button.visible = false
		return
	
	# Show Collect Food Button if:
	# player starts their turn on a food space
	# and they have room to collect more morsels
	if not 'collect_food' in actions_taken and current_char.can_collect_food():
		for food in food_spaces.get_children():
			if food.grid_pos[0] == current_char.grid_pos[0] and \
				food.grid_pos[1] == current_char.grid_pos[1]:
				collect_food_button.visible = true
				break
			else:
				collect_food_button.visible = false
	else:
		collect_food_button.visible = false
	
	if not 'movement' in actions_taken:
		finish_movement_button.visible = true
	else:
		finish_movement_button.visible = false

"""
FOOD
"""

func _on_collect_food_button_pressed():
	current_char.collect_food()
	current_char.use_action()
	actions_taken.append('collect_food')
	players_turn()

"""
MOVEMENT
"""

func _on_finish_movement_button_pressed():
	actions_taken.append('movement')
	current_char.use_action()
	players_turn()

"""
Find the space with the mouse pointer in it.
Then try and move the player to that space.
Hide the collect food button if the player does move.
"""
func move_char():
	if gamestate == State.PLAYER_TURN and current_char.can_act() and not 'movement' in actions_taken:
		for space in spaces.get_children():
			if space.has_mouse:
				if current_char.move_char(space.global_position, space.grid_pos):
					# Need to remove the option to collect food after moving
					collect_food_button.visible = false

