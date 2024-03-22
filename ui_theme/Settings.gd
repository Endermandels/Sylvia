extends Node

var theme = "res://ui_theme/default.tres"
var font_size = 20
var large_toggle = false
var dyslexia_toggle = false
var keyboard_toggle = false

func _ready():
	print("Keyboard controls: 
		Esc = exit scene
		Up, Down, Left, Right = change focus or move character
		Enter = selects highlighted button
		")
