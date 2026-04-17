extends Node
var mission_data: MissionData = preload("res://resources/missions/mission_data.tres")
var mission_select: PackedScene = preload("res://scenes/mission_select_c.tscn")

func _init() -> void:
	mission_data.missions[0].is_locked = false

func on_mission_success(mission: Mission):
	mission.is_finished = true
	for m in mission.unlocks:
		mission_data.missions[m].is_locked = false
	get_tree().call_deferred("change_scene_to_packed", mission_select)
		
func on_mission_fail(_mission: Mission):
	get_tree().call_deferred("change_scene_to_packed", mission_select)
