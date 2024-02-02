extends Node

@export var ACT = 2 # maximum number of actions
@export var MOV = 2 # maximum movement
@export var MOR = 3 # maximum morsel count
# Morsels are used for abilities and certain items.

var act = ACT
var mov = MOV
var mor = 0

func can_perform_act():
	return act > 0

func move(spaces):
	if act > 0:
		mov -= spaces
		if mov == 0:
			act -= 1
		if mov < 0:
			print('! Error: Moved too far')
			get_tree().quit()

func collect_morsel(amount):
	if act > 0:
		if mor < MOR:
			mor = min(mor + amount, MOR)
			act -= 1
		else:
			print('Cannot Exceed Maximum Morsel Count')

func reset():
	mov = MOV
	mor = MOR
	act = ACT
