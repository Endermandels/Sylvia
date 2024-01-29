extends Node

@export var mov = 2 # maximum movement
var mov_left = mov

func move(spaces):
	mov_left -= spaces

func reset():
	mov_left = mov
