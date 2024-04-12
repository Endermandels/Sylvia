class_name Run
extends Node

const BATTLE_SCENE := preload("res://battle/BattleScene.tscn")
const EVENT_SCENE := preload("res://Events/EventScene.tscn")
const SHOP_SCENE := preload("res://Shop/ShopScene.tscn")
const TREASURE_SCENE := preload("res://Treasure/TreasureScene.tscn")


@onready var CurrentView: Node = $CurrentView
@onready var Overworld: Node = $Overworld

var lastRoomEnteredType = map_space.Type.NO_TYPE

func _ready() -> void:
	Overworld.roomEntered.connect(_on_Overworld_roomEntered)

#this function would be used to implement loading saved games
func _start_run():
	pass

#given a scene, remove the old scene (if it exists) and add the new scene, making sure to connect
#the "completed" signal
func _change_view(scene: PackedScene) -> void:
	#CurrentView should have only 1 child (only have 1 scene on top of the map at a time)
	if CurrentView.get_child_count() > 0:
		CurrentView.get_child(0).queue_free()
	var new_view := scene.instantiate()
	new_view.completed.connect(_show_map)
	CurrentView.add_child(new_view)
	Overworld.hide_map()
	
#when exiting other scenes, call this
func _show_map() -> void:
	if lastRoomEnteredType == map_space.Type.BOSS:
		print("boss died lol")
	
	CurrentView.get_child(0).queue_free()
	Overworld.show_map()

func _on_Overworld_roomEntered(room: map_space.Type) -> void:
	match room:
		map_space.Type.ENEMY:
			lastRoomEnteredType = map_space.Type.ENEMY
			_change_view(BATTLE_SCENE)
		map_space.Type.EVENT:
			lastRoomEnteredType = map_space.Type.EVENT
			_change_view(EVENT_SCENE)
		map_space.Type.SHOP:
			lastRoomEnteredType = map_space.Type.SHOP
			_change_view(SHOP_SCENE)
		map_space.Type.TREASURE:
			lastRoomEnteredType = map_space.Type.TREASURE
			_change_view(TREASURE_SCENE)
		map_space.Type.BOSS:
			lastRoomEnteredType = map_space.Type.BOSS
			_change_view(BATTLE_SCENE)
		

