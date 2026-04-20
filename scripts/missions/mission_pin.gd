extends TextureButton
class_name MissionPin

signal mission_pressed(Mission)
signal mission_selected(Mission)

@export var FinishedMarker: CompressedTexture2D
@export var LockedMarker: CompressedTexture2D
@export var Markers: Array[CompressedTexture2D]
@export var MarkersFocus: Array[CompressedTexture2D]

var focused: bool
var mission : Mission

enum Difficulty {
	Green,
	Red,
	Orange,
	Yellow
}

func setup(m: Mission) -> void:
	mission = m
	if m.is_locked: 
		texture_normal = LockedMarker
		focus_mode = Control.FOCUS_NONE
		disabled = true
		return
	if m.is_finished:
		texture_normal = FinishedMarker
		focus_mode = Control.FOCUS_NONE
		disabled = true
		return
	texture_normal = Markers[m.difficulty]
	texture_focused = MarkersFocus[m.difficulty]

	
func _process(_delta: float) -> void:
	if focused:
		texture_normal = MarkersFocus[mission.difficulty]
		texture_hover = MarkersFocus[mission.difficulty]
	else: 
		texture_normal = Markers[mission.difficulty]
		texture_hover = Markers[mission.difficulty]

func _on_pressed():
	if not disabled:
		mission_pressed.emit(mission)

func _on_focus_entered():
	focused = true
	mission_selected.emit(mission)
	
func _on_focus_exited():
	focused = false
