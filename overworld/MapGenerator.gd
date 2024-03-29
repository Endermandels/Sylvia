
#this code was written following the guide on: 
#https://www.youtube.com/watch?v=7HYu7QXBuCY&t=6341s&ab_channel=GodotGameLab
#the github for the video's "starter project" is here:
#https://github.com/guladam/deck_builder_tutorial/tree/season-2-starter-project
#however only line.png was taken from the github

class_name MapGenerator
extends Node

var map_data: Array[Array]
#the distance between each node (the spacing between an array of dots)
const X_DIST := 60
const Y_DIST := 40
#setting to control how "wild" the map can look (how far each dot can vary from it's position)
const PLACEMENT_RANDOMNESS := 15
#i, the number of rows
const FLOORS := 8
#j, the width of the rows
const MAP_WIDTH := 4
#how many possible PATHS there can be
const PATHS := 3
#how many starting PATHS will be unique
const UNIQUE_PATHS := 2
#weighting for each map_space's chance when receiving a type
const ENEMY_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const EVENT_ROOM_WEIGHT := 4.0

var random_room_type_weights = {
	map_space.Type.ENEMY: 0.0,
	map_space.Type.SHOP: 0.0,
	map_space.Type.EVENT: 0.0
}
var random_room_type_total_weight := 0

func generate_map() -> Array[Array]:
	#generate an empty grid of map_spaces
	map_data = _generate_initial_grid()
	#get our starting points: a list with PATHS values, ranging from (0-MAP_WIDTH-1)
	#and containing at least 2 unique points, ie [1,1,1,1,1,2] or [4,3,2,6,5,4]
	var starting_points := _get_random_starting_points()
	#for each starting point, create a path from the starting point to the boss
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data
	
#returns a 2d array of map_spaces with position values initialized to match the 2d array,
#no next_rooms connections, and with enumeration type NO_TYPE
func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	for i in FLOORS:
		#make a new floor named adj_rooms to add to our result
		var adj_rooms: Array[map_space]= []
		#fill adj_rooms with new map_spaces
		for j in MAP_WIDTH:
			var current_room := map_space.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			#the offset is used to make the map look more interesting
			current_room.positioning = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			#boss room has no offset, is a little higher
			if i == FLOORS - 1:
				current_room.positioning.y = (i + 1) * -Y_DIST
			#add current room to the floor (aka adj_rooms)
			adj_rooms.append(current_room)
		#add the floor (aka adj_rooms) to our results
		result.append(adj_rooms)
	
	return result
	
#returns an array of ints of length PATHS to use as starting points, 
#ie [1, 3, 1, 4, 5, 1] or [2, 4, 4, 4, 4, 4]. guaranteed to have 2 unique values
func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	#keeps resetting until at least 2 unique points are rolled
	while unique_points < UNIQUE_PATHS:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			#this could potentially roll the same thing for each PATHS we want to take
			#ie [1,1,1,1,1,1] in which case the reset happens. [1,1,1,1,1,2] would pass
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
				
			y_coordinates.append(starting_point)
			
	return y_coordinates
	
#makes a connection from i, j to i+1 (next floor) and j-1, j, or j+1 
#calls a function before setup to ensure we do not cross paths with the left
#or right neighbors
func _setup_connection(i: int, j: int) -> int:
	#
	var next_room: map_space
	var current_room := map_data[i][j] as map_space
	#on first run next_room is false so it runs the loop, then on the next run
	#it checks _would_cross_existing_path() to make sure neither neighbor (j-1, j+1)
	#has a connection that would be crossed by this connection
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
	#add the connection
	current_room.next_rooms.append(next_room)
	
	return next_room.column
		
#returns true if the connection from [i,j] to map_space's i,j would cross
#any connections established by the left or right neighbor (j-1, j+1)
func _would_cross_existing_path(i: int, j: int, space: map_space) -> bool:
	var left_neighbor: map_space
	var right_neighbor: map_space
	
	#make sure we have a left neighbor and set it
	if j > 0:
		left_neighbor = map_data[i][j-1]
	#make sure we have a right neighbor and set it
	if j < MAP_WIDTH - 1:
		right_neighbor = map_data[i][j+1]
	
	#check our right neighbor and whether there's a chance we can cross connections
	if right_neighbor and space.column > j:
		for next_room: map_space in right_neighbor.next_rooms:
			if next_room.column < space.column: 
				return true
	
	#check our left neighbor and whether there's a chance we can cross connections
	if left_neighbor and space.column < j:
		for next_room: map_space in left_neighbor.next_rooms:
			if next_room.column > space.column:
				return true
				
	return false
	
	
	
func _setup_boss_room() -> void:
	var center := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS -1][center] as map_space
	
	#connect previous floor to all come to boss room
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS -2][j] as map_space
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[map_space]
			current_room.next_rooms.append(boss_room)
	
	boss_room.type = map_space.Type.BOSS

func _setup_random_room_weights() -> void:
	random_room_type_weights[map_space.Type.ENEMY] = ENEMY_ROOM_WEIGHT
	random_room_type_weights[map_space.Type.SHOP] = ENEMY_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	random_room_type_weights[map_space.Type.EVENT] = ENEMY_ROOM_WEIGHT + EVENT_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	

	random_room_type_total_weight = random_room_type_weights[map_space.Type.SHOP]
	
#changes all map_space types so they aren't NO_TYPE
func _setup_room_types() -> void:
	#1st floor is a battle
	for room: map_space in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = map_space.Type.ENEMY
		
	#4th floor is treasure
	for room: map_space in map_data[4]:
		if room.next_rooms.size() > 0:
			room.type = map_space.Type.TREASURE
			
	#set the rest of the floors
	for current_floor in map_data:
		#check each room on the floor
		for room: map_space in current_floor:
			#check the next_rooms of every room
			for next_room: map_space in room.next_rooms:
				#randomly set each floor
				if next_room.type == map_space.Type.NO_TYPE:
					_set_room_randomly(next_room)
	
#sets rooms randomly, enforces these rules:
#1) Shops cannot be consecutive
func _set_room_randomly(room_to_set: map_space) -> void:
	var consecutive_shop := true
	var type_candidate: map_space.Type
	
	#runs until consecutive_shop is false
	while consecutive_shop:
		type_candidate = _get_random_room_type_by_weight()
		var is_shop := type_candidate == map_space.Type.SHOP
		var parent_is_shop := _room_has_parent_of_type(room_to_set, map_space.Type.SHOP)
		consecutive_shop = is_shop and parent_is_shop
	
	room_to_set.type = type_candidate
	
func _room_has_parent_of_type(room: map_space, type: map_space.Type) -> bool:
	var parents: Array[map_space] = []
	#left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as map_space
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	#middle parent
	if room.row > 0:
		var parent_candidate := map_data[room.row -1][room.column] as map_space
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	#right parent
	if room.column < MAP_WIDTH-1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as map_space
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	#check all parents to see if they are the type we're looking for		
	for parent: map_space in parents:
		if parent.type == type:
			return true
	
	return false
	
	
func _get_random_room_type_by_weight() -> map_space.Type:
	#we will check each types weight against the roll, if the type is greater than the roll
	#we use that type. 
	var roll := randf_range(0.0, random_room_type_total_weight)
	for type: map_space.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll: 
			return type
			
	return map_space.Type.NO_TYPE
	
	
	
	
	
