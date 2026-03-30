extends MarginContainer
class_name Item

signal fade_ended(item: Item)
signal equip_button_pressed(item: ItemData)

@onready var fade_animation = $AnimationPlayer
@onready var button = $PanelContainer/VBoxContainer/Button

var item: ItemData
var focus_on_button := false

func setup(data: ItemData):
	item = data
	$PanelContainer/TextureRect.texture = data.icon
	$PanelContainer/VBoxContainer/title.text = data.display_name
	$PanelContainer/VBoxContainer/Desc.text = str(get_index())

func on_button_pressed() -> void:
	equip_button_pressed.emit(item)

func _on_focus_entered():
	focus_on_button = true
	button.grab_focus()
	fade_animation.play("fade")

func _on_focus_exited():
	_check_fade_back()

func _check_fade_back():
	if focus_on_button:	return
	fade_animation.play("fade_back")

func _on_button_focus_entered():
	focus_on_button = true

func _on_button_focus_exited() -> void:
	focus_on_button = false
	_check_fade_back()
	
func _on_animation_end(anim_name: StringName):
	if anim_name == "fade":	fade_ended.emit(self)
