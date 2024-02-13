extends Node2D


@onready var collision = $CollisionShape2D
@onready var tex = $Sprite2D.texture.resource_path

func _on_texture_button_pressed():
	if tex == "res://assets/map_enemy.png":
		get_tree().change_scene_to_file("res://battle/BattleScene.tscn")
