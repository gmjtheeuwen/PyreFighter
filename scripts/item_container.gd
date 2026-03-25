extends VBoxContainer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT:
			animation_player.stop()
			animation_player.play("fade_back")

func _controller_input(event: InputEvent) -> void:
	if not has_focus():
		return
	if event.is_action_pressed("ui_cancel"):
		animation_player.stop()
		animation_player.play("fade_back")

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_back":
		get_parent().get_node("TextureRect").grab_focus()
