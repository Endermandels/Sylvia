class_name MapRoom
extends Area2D

signal selected(room: map_space)

#dictionary with [icon, scale]
const ICONS := {
	map_space.Type.NO_TYPE: [preload("res://assets/ex.png"), Vector2.ONE],
	map_space.Type.ENEMY: [preload("res://assets/horn.png"), Vector2(.7,.7)],
	map_space.Type.EVENT: [preload("res://assets/heart.png"), Vector2.ONE],
	map_space.Type.SHOP: [preload("res://assets/check.png"), Vector2.ONE],
	map_space.Type.TREASURE: [preload("res://assets/apple.png"), Vector2.ONE],
	map_space.Type.BOSS: [preload("res://assets/enemy.png"), Vector2(.5, .5)],
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: map_space : set = set_room


func set_available(new_value: bool) -> void:
	available = new_value
	
	if available: 
		animation_player.play("highlight_map_space")
	elif not room.selected:
		animation_player.play("RESET")
		
func set_room(new_data: map_space) -> void:
	room = new_data
	position = room.positioning
	line_2d.rotation_degrees = randi_range(0, 360)
	#set texture
	sprite_2d.texture = ICONS[room.type][0]
	#set scale
	sprite_2d.scale = ICONS[room.type][1]
	
func show_selected() -> void:
	line_2d.modulate = Color.WHITE
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	animation_player.play("select_map_space")
	
#called by AnimationPlayer when the select animation finishes
func _on_map_room_selected() -> void:
	selected.emit(room)
