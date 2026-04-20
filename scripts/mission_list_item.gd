extends PanelContainer
class_name MissionListItem

var mission: Mission
var title: String

@onready var icon_container = $MarginContainer/VBoxContainer/EnemyTypeIconContainer
@onready var title_label: Label = $MarginContainer/VBoxContainer/Title

func _ready() -> void:
	title_label.text = mission.title
	icon_container.update_enemy_types(mission.enemy_types.duplicate())

func _on_focus_entered():
	var stylebox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	stylebox.border_color = Color.WHITE
	stylebox.border_width_left = 4
	stylebox.border_width_top = 4
	stylebox.border_width_right = 4
	stylebox.border_width_bottom = 4
	add_theme_stylebox_override("panel", stylebox)

func _on_focus_exited():
	remove_theme_stylebox_override("panel")
	
