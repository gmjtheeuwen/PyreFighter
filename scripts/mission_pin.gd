extends TextureButton
class_name MissionPin

signal mission_pressed(Mission)

@export var Markers: Array[CompressedTexture2D]
@export var MarkersFocus: Array[CompressedTexture2D]
var mission : Mission

enum Difficulty {
	Green,
	Red,
	Orange,
	Yellow
}

func setup(m: Mission) -> void:
	mission = m
	texture_normal = Markers[m.difficulty]
	texture_hover = MarkersFocus[m.difficulty]
	texture_focused = MarkersFocus[m.difficulty]

func _on_pressed():
	mission_pressed.emit(mission)
