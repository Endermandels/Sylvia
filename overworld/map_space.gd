
#this code was written following the guide on: 
#https://www.youtube.com/watch?v=7HYu7QXBuCY&t=6341s&ab_channel=GodotGameLab
#the github for the video's "starter project" is here:
#https://github.com/guladam/deck_builder_tutorial/tree/season-2-starter-project
#however only line.png was taken from the github

#a basic node to hold information about the different rooms
#we create a 2D array of these as the data for the map
class_name map_space
extends Node2D

enum Type {NO_TYPE, ENEMY, EVENT, SHOP, TREASURE, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var positioning: Vector2
@export var next_rooms: Array[map_space]
@export var selected: = false
