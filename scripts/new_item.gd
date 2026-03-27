extends MarginContainer
class_name Item

signal equip_button_pressed(item: ItemData)

@onready var fade_animation = $AnimationPlayer

var item: ItemData

func setup(data: ItemData):
	item = data
	$PanelContainer/TextureRect.texture = data.icon
	$PanelContainer/VBoxContainer/title.text = data.display_name
	$PanelContainer/VBoxContainer/Desc.text = data.description

func on_button_pressed() -> void:
	equip_button_pressed.emit(item)

func _on_focus_entered():
	fade_animation.play("fade")

func _on_focus_exited():
	fade_animation.play_backwards("fade")
