extends VBoxContainer
class_name MissionList

signal selected_mission_changed(mission: Mission)

@onready var mission_list_item = preload("res://scenes/mission_list_item.tscn")

var mission_list: Array[Mission]
var selected_mission: Mission
	
func _ready() -> void:
	for mission in mission_list:
		if not mission.is_locked:
			var item: MissionListItem = mission_list_item.instantiate()
			item.mission = mission
			item.focus_entered.connect(_on_child_focus.bind(item.mission))
			add_child(item)
			if mission.is_finished:
				item.title_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))

func _on_child_focus(mission: Mission):
	if (selected_mission != mission): 
		selected_mission = mission
		selected_mission_changed.emit(mission)
