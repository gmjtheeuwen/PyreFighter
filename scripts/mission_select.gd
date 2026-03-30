extends Control
class_name MissionSelect

@onready var mission_data = preload("res://resources/missions/mission_data.tres")
@onready var mission_pin_scene = preload("res://scenes/mission_pin.tscn")

@onready var map = $HBoxContainer/CenterContainer/Map

func _ready() -> void:
	for i in range(mission_data.missions.size()):
		var mission = mission_data.missions[i] as Mission
		var pin = mission_pin_scene.instantiate()
		pin.setup(mission)
		pin.name = "Mission_%s" % i 
		pin.position = mission.location * map.size
		pin.mission_pressed.connect(start_mission)
		map.add_child(pin)
		
	map.get_children()[0].grab_focus()

func start_mission(mission: Mission):
	get_tree().call_deferred("change_scene_to_packed", mission.scene)
