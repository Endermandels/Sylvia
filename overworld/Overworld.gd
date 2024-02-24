class_name Overworld
extends Node2D

const SCROLL_SPEED := 15
const MAP_ROOM = preload("res://overworld/map_room.tscn")
const MAP_LINE = preload("res://overworld/map_line.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var floors_climbed: int
var last_room: map_space
var camera_edge_y: float

func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)
	generate_new_map()
	unlock_floor(0)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)	
	
func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()
	
func create_map() -> void:
	for current_floor: Array in map_data:
		for room: map_space in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	#boss room has no next_rooms
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[MapGenerator.FLOORS-1][middle])
		
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) /2
	visuals.position.y = get_viewport_rect().size.y /2
		
func unlock_floor(which_floor: int = floors_climbed) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true
			
func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.getchildren():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true
			
func show_map() -> void:
	show()
	camera_2d.enabled = true
	
func hide_map() -> void:
	hide()
	camera_2d.enabled = false
	
func _spawn_room(room: map_space) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	#for loading saved game
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()
		
func _connect_lines(room: map_space) -> void:
	if room.next_rooms.is_empty():
		return
		
	for next: map_space in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.positioning)
		new_map_line.add_point(next.positioning)
		lines.add_child(new_map_line)
		
		
func _on_map_room_selected(room: map_space) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
			
	last_room = room
	floors_climbed += 1
	
	get_tree().change_scene_to_file("res://battle/BattleScene.tscn")
	
	
	
