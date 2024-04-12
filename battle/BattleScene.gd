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

signal completed

# Keeps track of game states
enum State {
	PLAYER_TURN,
	ENEMY_TURN,
	PLAYER_WON,
	PLAYER_LOST
}

@onready var collect_food_button = $UI/Control/CollectFoodButton
@onready var finish_movement_button = $UI/Control/FinishMovementButton
@onready var attack_button = $UI/Control/AttackButton
@onready var pause_menu = $CanvasLayer/PauseMenu

@onready var food_spaces = $FoodSpaces
@onready var spaces = $Spaces
@onready var cards = $BattleUI/Hand
@onready var enemies = $Enemies
@onready var food_counter = $FoodCounter
@onready var audio_manager = $AudioManager
@onready var characters = $Characters

var gamestate = State.PLAYER_TURN
var actions_taken = []

# The various enemies and player characters are ordered by turn in this list
var battle_queue = [] # TODO: Implement

# Names of all the enemies currently on the board.

# Enemies affected by character abilities or attacks
var affected_enemies = []
var affected_food = []

# Reference to the current character
var current_char = null

var moving = false
var paused = false


var enemies_completed_turn = 0
signal enemys_turn

"""
SETUP
"""

func _ready():
	audio_manager.playMusic("res://Music/battle_music (surf).ogg")
	set_process_input(true)
	hide_nodes()
	decide_turn_order()
	current_char.save_stats()
	spawn_enemies( 7)
	players_turn()

func hide_nodes():
	collect_food_button.visible = false

"""
Decides using base movement speed of each unit in battle.
"""
func decide_turn_order():
	# TODO: Implement
	current_char = $"Characters/Clover"
	
func spawn_enemies( num_cols):
	for enemy in enemies.get_children():
		enemy.enemy_pos = [randi() % num_cols, 0]
		enemy.update_visual_position((enemy.enemy_pos))
	#	enemy.enemys_turn.connect(_on_battle_scene_enemys_turn)
		

"""
INPUT
"""

func _input(event):
	if event is InputEventMouseButton:
		if not paused and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				move_char()
		elif not paused and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				for enemy in affected_enemies:
					enemy.stats.load_stats()
				
				for food in affected_food:
					food.load_stats()
				
				current_char.load_stats()
				food_counter.set_count(current_char.stats.mor)
				
				affected_enemies = []
				affected_food = []
				actions_taken = []
				moving = false
				
				players_turn()
	elif event.is_action_pressed("ui_cancel"):
		exit()
	elif event.is_action_pressed("pause"):
		pauseMenu()
	elif event.is_action_pressed("horn"):
		_on_end_of_turn_end_turn()
	else:
		keyboard_move_char(event)
		
func pauseMenu():
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()
	paused = !paused

func keyboard_move_char(event):
	var new_row = current_char.grid_pos[1]
	var new_col = current_char.grid_pos[0]
	if event.is_action_pressed("ui_up"):
		new_row = max(new_row - 1, 0)
	elif event.is_action_pressed("ui_down"):
		new_row = min(new_row + 1, 4)
	elif event.is_action_pressed("ui_left"):
		new_col = max(new_col - 1, 0)
	elif event.is_action_pressed("ui_right"):
		new_col = min(new_col + 1, 6)
	var index = new_row * 7 + new_col
	var space = spaces.get_children()[index]
	if gamestate == State.PLAYER_TURN and current_char.can_act() and not 'movement' in actions_taken:
		if current_char.move_char(space.global_position, space.grid_pos):
			# Need to remove other actions while moving
			collect_food_button.visible = false
			attack_button.visible = false
			finish_movement_button.visible = true
			moving = true

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
Check if the player has successfully won.
"""
func _on_enemy_end_turn():
	enemies_completed_turn += 1
	if enemies_completed_turn >= enemies.get_child_count():
		# All enemies have completed their turn
		enemies_completed_turn = 0  # Reset for the next round
		if player_won():
			gamestate = State.PLAYER_WON
			
			print('player won!')
			return
		
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
Player wins by having all creatures on top row without any enemies adjacent to their creatures.
"""
func player_won():
	
	if all_enemies_died():
		completed.emit()
		return true
	
	for character in characters.get_children():
		for enemy in enemies.get_children():
			var grid_pos = character.grid_pos
			var enemy_pos = enemy.enemy_pos
			
			if grid_pos == [-1, -1]: #this is because apon death the grid pos gets set to this
				return false
			# Must be on top row
			if grid_pos[1] > 0:
				return false
			
			# Check for adjacent enemies
			if grid_pos[0] - 1 >= 0 and grid_pos[0]-1 == enemy_pos[0] and grid_pos[1] == enemy_pos[1]:
				return false
			if grid_pos[1] - 1 >= 0 and grid_pos[0] == enemy_pos[0] and grid_pos[1]-1 == enemy_pos[1]:
				return false
			if grid_pos[0] + 1 < character.grid_cols and \
				grid_pos[0]+1 == enemy_pos[0] and grid_pos[1] == enemy_pos[1]:
				return false
			if grid_pos[1] + 1 < character.grid_rows and \
				grid_pos[0]-1 == enemy_pos[0] and grid_pos[1] == enemy_pos[1]:
				return false
	completed.emit()
	return true


"""All Enemies have died"""

func all_enemies_died():
	for enemy in enemies.get_children():
		if enemy.alive == true:
			return false
	return true
	
"""Player Lost, by having all characters be dead"""

func player_lost():
	for character in characters.get_children():
		if character.alive == true:
			return false
	return true


"""
Either enemy just ended their turn or player has used an action.
"""
func players_turn():
	
	if player_lost():
		print("Player Lost")
		gamestate = State.PLAYER_TURN
	
	
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
	food_counter.increment_count(1)
	
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
			if space.has_mouse and grid_space_free(space.grid_pos):
				if current_char.move_char(space.global_position, space.grid_pos):
					# Need to remove other actions while moving
					collect_food_button.visible = false
					attack_button.visible = false
					finish_movement_button.visible = true
					moving = true

#check to ensure that the grid space is free of characters and enemies.
func grid_space_free(grid_pos):
	for enemy in enemies.get_children():
		if enemy.enemy_pos == grid_pos:
			return false
	for character in characters.get_children():
		if character.grid_pos == grid_pos:
			return false
	return true

"""
ATTACK
"""
func _on_attack_button_pressed():
	audio_manager.playSFX("attack")
	print('attack')
	var enemies_in_range = enemies_in_range(current_char.get_attack_range())
	
	for enemy in enemies_in_range:
		enemy.stats.save_stats()
		if not enemy in affected_enemies:
			affected_enemies.append(enemy)
		current_char.attack(enemy)
	
	current_char.use_action()
	actions_taken.append('attack')
	enemies_in_range = []
	
	if player_won():
			gamestate = State.PLAYER_WON
			print('Player won!')
			return
			
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
	print(in_range)
	return in_range

"""
Ability
"""

func _on_hand_play_card(card, targets):
	if not moving:
		if gamestate == State.PLAYER_TURN and current_char.can_act() and \
			not 'ability' in actions_taken and current_char.can_use_ability(card.stats):
			for enemy in enemies.get_children():
				# TODO: Affect multiple targets
				print(enemy.enemy_pos, targets[0].grid_pos)
				if enemy.enemy_pos[0] == targets[0].grid_pos[0] and \
					enemy.enemy_pos[1] == targets[0].grid_pos[1]:
					print('playing', card.stats.ability_name)
					
					if not enemy in affected_enemies:
						affected_enemies.append(enemy)
					
					current_char.use_ability(card.stats, enemy)
					current_char.use_action()
					food_counter.decrement_count(card.stats.cost)
					actions_taken.append('ability')
					
					if player_won():
						gamestate = State.PLAYER_WON
						print('Player won!')
						return
					players_turn()
					break

func exit():
	get_tree().change_scene_to_file("res://start_menu/start_menu.tscn")
