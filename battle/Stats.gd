extends Node

@export var mov = 2
var mov_left = mov

func move(spaces):
	mov_left -= spaces

