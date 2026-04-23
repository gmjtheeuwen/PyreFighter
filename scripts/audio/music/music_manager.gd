class_name music_manager
extends Node

@onready var hub_player = $MusicHub
@onready var mission_player = $MusicMission

var current_player: AudioStreamPlayer = null
var is_transitioning: bool = false

func _ready():
	hub_player.play()
	current_player = hub_player
	get_tree().scene_changed.connect(on_scene_changed)

func on_scene_changed():
	var current_scene = get_tree().current_scene
	if current_scene is MissionScene:
		play_mission()
	else:
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
		current_player.stop()
	
	new_player.volume_db = -80.0
	new_player.play()
	var fade_in = create_tween()
	fade_in.tween_property(new_player, "volume_db", 0.0, 2.0)
	await fade_in.finished
	
	current_player = new_player
	is_transitioning = false
