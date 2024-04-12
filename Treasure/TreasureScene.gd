class_name Treasure
extends Node2D

signal completed

@onready var treasure: Node2D = $Treasure/Area2D/Treasure_Click_Area/Treasure_Sprite
var open_sprite = preload("res://assets/treasure_open.png")
var closed_sprite = preload("res://assets/treasure.png")

func test_button_signal_completed() -> void:
	completed.emit()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			treasure.texture = open_sprite
		if event.button_index == MOUSE_BUTTON_RIGHT:
			treasure.texture = closed_sprite
