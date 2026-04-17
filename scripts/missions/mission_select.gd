extends Control
class_name MissionSelect

@onready var mission_pin_scene = preload("res://scenes/mission_pin.tscn")
@onready var map = $HBoxContainer/CenterContainer/Map
@onready var title_label = $HBoxContainer/CenterContainer2/VBoxContainer/Title
@onready var description_label = $HBoxContainer/CenterContainer2/VBoxContainer/Description

func _ready() -> void:
	var mission_data = MissionManager.mission_data
	for i in range(mission_data.missions.size()):
		var mission = mission_data.missions[i] as Mission
		var pin = mission_pin_scene.instantiate()
		pin.setup(mission)
		pin.name = "Mission_%s" % i 
		pin.position = mission.location * map.size
		pin.mission_selected.connect(update_overview)
		pin.mission_pressed.connect(start_mission)
		map.add_child(pin)
		
	grab_focus_first()
	
func update_overview(mission: Mission):
	title_label.text = mission.title
	description_label.text = mission.description
	
func grab_focus_first():
	for p in map.get_children():
		var pin = p as MissionPin
		if pin.focus_mode != FocusMode.FOCUS_NONE:
			pin.grab_focus()
			return

func start_mission(mission: Mission):
	get_tree().call_deferred("change_scene_to_file", mission.scene)
