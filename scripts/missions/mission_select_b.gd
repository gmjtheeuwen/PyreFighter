extends Control

var icon_scene = preload("res://scenes/enemy_type_icon.tscn")

@onready var mission_pin_scene = preload("res://scenes/mission_pin.tscn")
@onready var mission_list_scene = preload("res://scenes/mission_list.tscn")

@onready var mission_list_container = $HBoxContainer/CenterContainer2/VBoxContainer/MissionListContainer
@onready var details_container = $HBoxContainer/CenterContainer/DetailsContainer
@onready var title_label = $HBoxContainer/CenterContainer/DetailsContainer/Title
@onready var description_label = $HBoxContainer/CenterContainer/DetailsContainer/Description
@onready var reward_label = $HBoxContainer/CenterContainer/DetailsContainer/Rewards
@onready var enemy_type_label = $HBoxContainer/CenterContainer/DetailsContainer/HBoxContainer/EnemyTypeLabel
@onready var icon_container = $HBoxContainer/CenterContainer/DetailsContainer/HBoxContainer/IconContainer
@onready var start_button: Button = $HBoxContainer/CenterContainer/DetailsContainer/StartButton

func _ready() -> void:	
	var mission_data = MissionManager.mission_data
	var mission_list: MissionList = mission_list_scene.instantiate()
	mission_list.mission_list = mission_data.missions.duplicate()
	mission_list_container.add_child(mission_list)	
	mission_list.selected_mission_changed.connect(_on_selected_mission_changed)
	mission_list_container.get_child(0).get_child(0).grab_focus()
	

func update_overview(mission: Mission):
	title_label.text = mission.title
	description_label.text = mission.description
	reward_label.text = "Experience: %s" % mission.experience	
	
	enemy_type_label.visible = mission.enemy_types.size() > 0
	icon_container.update_enemy_types(mission.enemy_types)
	start_button.focus_neighbor_left = get_mission_list_item(mission)
	start_button.pressed.disconnect(start_mission)
	start_button.pressed.connect(start_mission.bind(mission))
	
	
func get_mission_list_item(mission: Mission) -> NodePath:
	for item: MissionListItem in mission_list_container.get_child(0).get_children():
		if item.mission == mission:
			return item.get_path()
	return ""
func get_enemy_type_icons(mission: Mission) -> Array[TextureRect]:
	var icon_nodes: Array[TextureRect]
	for type in range(Flame.FuelType.values().size()):
		if mission.enemy_types.has(type):
			var icon = icon_scene.instantiate()
			var texture_name = "res://assets/icons/Icon%s.png" % str(Flame.FuelType.keys()[type]).capitalize()
			icon.texture = load(texture_name)
			icon_nodes.append(icon)
	return icon_nodes
	
func _on_selected_mission_changed(mission: Mission):
	update_overview(mission)

func start_mission(mission: Mission):
	get_tree().call_deferred("change_scene_to_file", mission.scene)
