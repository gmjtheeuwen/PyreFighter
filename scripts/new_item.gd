extends MarginContainer
class_name Item

signal equip_button_pressed(item: ItemData)

@onready var fade_animation = $AnimationPlayer

var item: ItemData
var focus_on_button := false

func setup(data: ItemData):
	item = data
	$PanelContainer/TextureRect.texture = data.icon
	$PanelContainer/VBoxContainer/title.text = data.display_name
	$PanelContainer/VBoxContainer/Desc.text = data.description

func on_button_pressed() -> void:
	equip_button_pressed.emit(item)

func _on_focus_entered():
	focus_on_button = false
	fade_animation.play("fade")

func _on_focus_exited():
	call_deferred("_check_fade_back")

func _check_fade_back():
	if focus_on_button:
		return
	fade_animation.play_backwards("fade")

func _on_button_focus_entered():
	focus_on_button = true

func _on_button_focus_exited() -> void:
	focus_on_button = false
	_check_fade_back()
