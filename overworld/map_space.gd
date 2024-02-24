class_name map_space
extends Node2D

enum Type {NO_TYPE, ENEMY, EVENT, SHOP, TREASURE, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var positioning: Vector2
@export var next_rooms: Array[map_space]
@export var selected: = false

func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][1]]
