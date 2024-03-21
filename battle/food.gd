extends Node2D

@onready var sprite = $Sprite2D
@onready var hitbox = $Area2D
@onready var parent = get_parent()

@export var grid_pos = [2, 2]
var saved_rand_space = null # Previously-generated random space
var origin = [] # Keeps track of original position, in case the board is reset

func rand_pos(spaces):
	var x = null
	var space = null
	
	if not saved_rand_space or saved_rand_space.grid_pos == grid_pos:
		while not space:
			x = randi_range(0, len(spaces.get_children())-1)
			space = spaces.find_child("Space" + str(x))
			
			for food in parent.get_children():
				if food.name != self.name and food.grid_pos == space.grid_pos:
					space = null
					break
		
		saved_rand_space = space
	else:
		space = saved_rand_space
	
	grid_pos = space.grid_pos.duplicate()
	sprite.global_position = space.global_position
	hitbox.global_position = sprite.global_position

# Used after player passes their turn to the enemy
func reset_saved_rand_space():
	saved_rand_space = null

func save_stats():
	origin = [sprite.global_position, grid_pos.duplicate()]

func load_stats():
	grid_pos = origin[1].duplicate()
	sprite.global_position = origin[0]
	hitbox.global_position = origin[0]
