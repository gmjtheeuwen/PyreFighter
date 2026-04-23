class_name player_sfx
extends Node2D

@onready var death_static = $NoiseDeath
@onready var hurt_player = $NoiseHurt

var static_playback: AudioStreamGeneratorPlayback
var is_static_playing: bool = false

func play_death_static():
	death_static.volume_db = -80.0
	death_static.play()
	static_playback = death_static.get_stream_playback()
	is_static_playing = true
	
	var tween = create_tween()
	# left volume right time taken for fade
	tween.tween_property(death_static, "volume_db", 0.0, 1.0)
	tween.tween_property(death_static, "volume_db", -15.0, 1.0)
	
	await get_tree().create_timer(4.0).timeout
	
	var fade_out = create_tween()
	fade_out.tween_property(death_static, "volume_db", -80.0, 0.5)
	await fade_out.finished
	is_static_playing = false
	death_static.stop()

func _process(_delta: float):
	if is_static_playing and static_playback:
		_fill_static()

func _fill_static():
	var frames = static_playback.get_frames_available()
	for i in range(frames):
		static_playback.push_frame(Vector2.ONE * randf_range(-1.0, 1.0))

func play_hurt():
	var temp_player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(temp_player)
	temp_player.stream = hurt_player.stream
	temp_player.pitch_scale = randf_range(0.9, 1.1)
	temp_player.volume_db = hurt_player.volume_db
	temp_player.bus = hurt_player.bus
	temp_player.play()
	temp_player.finished.connect(temp_player.queue_free)
