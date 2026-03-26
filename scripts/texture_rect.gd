extends TextureRect
@export var animation_player: AnimationPlayer

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT:
			animation_player.play("fade")

func play_fade():
	animation_player.play("fade")

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade":
		get_parent().get_parent().emit_signal("fade_completed")
