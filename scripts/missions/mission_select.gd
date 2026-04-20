extends Control
class_name MissionSelect

var icon_scene = preload("res://scenes/enemy_type_icon.tscn")

@onready var mission_pin_scene = preload("res://scenes/mission_pin.tscn")
@onready var map = $HBoxContainer/CenterContainer/Map
@onready var title_label = $HBoxContainer/VBoxContainer/CenterContainer2/VBoxContainer/Title
@onready var description_label = $HBoxContainer/VBoxContainer/CenterContainer2/VBoxContainer/Description
@onready var reward_label = $HBoxContainer/VBoxContainer/CenterContainer2/VBoxContainer/Rewards
@onready var icon_container = $HBoxContainer/VBoxContainer/CenterContainer2/VBoxContainer/EnemyTypes

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		
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
	reward_label.text = "Experience: %s" % mission.experience
	for icon in icon_container.get_children():
		icon_container.remove_child(icon)
	for icon in get_enemy_type_icons(mission):
		icon_container.add_child(icon)
	
func get_enemy_type_icons(mission: Mission) -> Array[TextureRect]:
	var icon_nodes: Array[TextureRect]
	for type in range(Flame.FuelType.values().size()):
		if mission.enemy_types.has(type):
			var icon = icon_scene.instantiate()
			var texture_name = "res://assets/icons/Icon%s.png" % str(Flame.FuelType.keys()[type]).capitalize()
			icon.texture = load(texture_name)
			icon_nodes.append(icon)
	return icon_nodes
	
func grab_focus_first():
	for p in map.get_children():
		var pin = p as MissionPin
		if pin.focus_mode != FocusMode.FOCUS_NONE:
			pin.grab_focus()
			return

func start_mission(mission: Mission):
	get_tree().call_deferred("change_scene_to_file", mission.scene)
