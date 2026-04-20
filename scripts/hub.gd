extends Node2D
class_name Hub

enum Position{
	CENTER,
	DOOR,
	MISSION,
	EQUIPMENT
}

@onready var player = $Player

func _ready() -> void:
	player.position = HubManager.get_player_position()

func on_mission_select_interact():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mission_select_c.tscn")

func on_equipment_interact():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/inventory.tscn")
