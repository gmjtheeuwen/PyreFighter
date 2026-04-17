extends Node2D

@export var mission: Resource

func on_mission_finish(success: bool = true):
	if success:	MissionManager.on_mission_success(mission)
	else: MissionManager.on_mission_fail(mission)
