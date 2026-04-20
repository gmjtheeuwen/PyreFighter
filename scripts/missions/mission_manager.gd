extends Node

var mission_data: MissionData = preload("res://resources/missions/mission_data.tres")
var hub: PackedScene = preload("res://scenes/hub.tscn")

func _init() -> void:
	mission_data.missions[0].is_locked = false

func on_mission_success(mission: Mission):
	mission.is_finished = true
	for m in mission.unlocks:
		mission_data.missions[m].is_locked = false
	
	HubManager.set_player_position(mission.player_hub_position)
	get_tree().call_deferred("change_scene_to_packed", hub)
		
func on_mission_fail(_mission: Mission):
	get_tree().call_deferred("change_scene_to_packed", hub)
