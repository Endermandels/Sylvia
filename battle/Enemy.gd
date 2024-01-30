extends Node2D

signal end_turn

func _on_battle_scene_enemys_turn():
	print('enemy does something')
	emit_signal("end_turn")
