extends Node

# Unit Stats
@export var HP = 5
@export var ATK = 2
@export var ACT = 2 # maximum number of actions
@export var MOV = 2 # maximum movement
@export var MOR = 3 # maximum morsel count
# Morsels are used for abilities and certain items.

# Stats below are for the player.
var hp = HP
var atk = ATK
var act = ACT
var mov = MOV
var mor = 0

# Stats below are for the enemy.
var enemy_hp = HP
var enemy_atk = ATK
var enemy_act = ACT
var enemy_mov = MOV

func can_perform_act():
	return act > 0

func can_collect_morsel():
	return mor < MOR

func move(spaces):
	mov -= spaces

func receiveDMG(damage):
	hp -= damage

func use_action():
	act -= 1

func reset():
	mov = MOV
	act = ACT

func collect_morsel(amount):
	mor = min(mor + amount, MOR)
	print('Collected Morsel.  mor: ' + str(mor))
