extends TextureRect
@export var animation_player: AnimationPlayer

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT:
			animation_player.play("fade")
