class_name music_manager
extends Node

@onready var hub_player = $MusicHub
@onready var mission_player = $MusicMission

var current_player: AudioStreamPlayer = null
var is_transitioning: bool = false

func _ready():
	play_hub()

func play_hub():
	_crossfade(hub_player)

func play_mission():
	_crossfade(mission_player)

func _crossfade(new_player: AudioStreamPlayer):
	if is_transitioning: return
	if current_player == new_player: return
	is_transitioning = true
	
	if current_player != null:
		var fade_out = create_tween()
		fade_out.tween_property(current_player, "volume_db", -80.0, 1.0)
		await fade_out.finished
		current_player.stop()
	
	new_player.volume_db = -80.0
	new_player.play()
	var fade_in = create_tween()
	fade_in.tween_property(new_player, "volume_db", 0.0, 1.0)
	await fade_in.finished
	
	current_player = new_player
	is_transitioning = false
