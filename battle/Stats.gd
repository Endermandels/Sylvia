extends Node

@onready var heartsContainer = $"../Sprite2D/heartsContainer"
# Unit Stats
@export var HP = 5
@export var ATK = 2
@export var ACT = 2 # maximum number of actions
@export var MOV = 2 # maximum movement
@export var MOR = 3 # maximum morsel count
# Morsels are used for abilities and certain items.

# Coordinates from unit's grid position
@export var attack_range = [[0,1],[0,-1],[1,0],[-1,0]]

@onready var hp = HP
@onready var atk = ATK
@onready var act = ACT
@onready var mov = MOV
@onready var mor = 0

@onready var saved_hp = hp
@onready var saved_atk = atk
@onready var saved_act = act
@onready var saved_mov = mov
@onready var saved_mor = mor

func can_perform_act():
	return act > 0

func can_collect_morsel():
	return mor < MOR

func can_use_ability(card_stats):
	return card_stats.cost <= mor

func get_attack_range():
	return attack_range

func move(spaces):
	mov -= spaces

func receiveDMG(damage):
	hp -= damage
	
	#temporarily set hp back to max hp when player dies
	if hp <= 0:
		print("Unit Died, resetting HP...")
		hp = HP
		
	#update hearts container
	heartsContainer.setHearts(hp)
	 

func use_action():
	act -= 1

func use_ability(card_stats, enemy):
	card_stats.apply_effects(enemy)
	mor -= card_stats.cost

func save_stats():
	saved_hp = hp
	saved_atk = atk
	saved_act = act
	saved_mov = mov
	saved_mor = mor

func load_stats():
	print("stats loaded")
	hp = saved_hp
	atk = saved_atk
	act = saved_act
	mov = saved_mov
	mor = saved_mor
	heartsContainer.setHearts(hp)

func reset():
	mov = MOV
	act = ACT

func collect_morsel(amount):
	mor = min(mor + amount, MOR)
	print('Collected Morsel.  mor: ' + str(mor))
