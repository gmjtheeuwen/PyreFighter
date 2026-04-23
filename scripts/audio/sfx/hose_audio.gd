class_name HoseAudio
extends Node2D

@onready var player_low = $NoisePlayerLow
@onready var player_mid = $NoisePlayerMid
@onready var player_high = $NoisePlayerHigh

var playback_low: AudioStreamGeneratorPlayback
var playback_mid: AudioStreamGeneratorPlayback
var playback_high: AudioStreamGeneratorPlayback

var sample_rate: float = 22050.0


# Pink noise state
var b0_l = 0.0; var b1_l = 0.0; var b2_l = 0.0
var b0_m = 0.0; var b1_m = 0.0; var b2_m = 0.0
var b0_h = 0.0; var b1_h = 0.0; var b2_h = 0.0

# Modulation phases for each layer
var phase_low: float = 0.0
var phase_mid: float = 0.0
var phase_high: float = 0.0

var is_firing: bool = false
var current_agent: int = 1

const AGENT_MOD = {
	1: [3.0,  6.0,  11.0, 0.06, 0.08, 0.04], # Water
	2: [5.0,  8.0,  13.0, 0.07, 0.10, 0.06], # Foam
	3: [6.0,  10.0, 14.0, 0.05, 0.08, 0.08], # Powder
	4: [8.0,  12.0, 16.0, 0.03, 0.06, 0.10]  # CO2
}

const AGENT_EQ = {
	1: { # Water
		"low":  [6.0, 6.0, 4.0, 2.0, -2.0, -4.0, -4.0, -6.0, -6.0, -8.0],
		"mid":  [-6.0, -4.0, 0.0, 4.0, 6.0, 6.0, 2.0, -2.0, -6.0, -8.0],
		"high": [-8.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 6.0, 8.0, 8.0]
	},
	2: { # Foam
		"low":  [2.0, 2.0, 1.0, 0.0, -3.0, -5.0, -5.0, -7.0, -7.0, -9.0],
		"mid":  [-8.0, -6.0, 2.0, 8.0, 10.0, 8.0, 4.0, -2.0, -6.0, -8.0],
		"high": [-8.0, -8.0, -6.0, -4.0, -4.0, -2.0, 0.0, 2.0, 4.0, 4.0]
	},
	3: { # Powder
		"low":  [-6.0, -6.0, -4.0, -2.0, -4.0, -6.0, -6.0, -8.0, -8.0, -10.0],
		"mid":  [-8.0, -8.0, -6.0, -4.0, -6.0, -4.0, -2.0, 0.0, -4.0, -6.0],
		"high": [-8.0, -8.0, -4.0, -2.0, 0.0, 2.0, 6.0, 10.0, 10.0, 8.0]
	},
	4: { # CO2
		"low":  [-10.0, -10.0, -10.0, -8.0, -8.0, -8.0, -6.0, -4.0, -2.0, 0.0],
		"mid":  [-10.0, -10.0, -10.0, -8.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0],
		"high": [-10.0, -8.0, -4.0, 0.0, 2.0, 4.0, 6.0, 10.0, 12.0, 12.0]
	}
}

func _ready():
	player_low.play()
	player_mid.play()
	player_high.play()
	playback_low = player_low.get_stream_playback()
	playback_mid = player_mid.get_stream_playback()
	playback_high = player_high.get_stream_playback()
	_update_bus_effects()

func _process(_delta):
	if is_firing:
		_fill_buffer()

func _fill_buffer():
	var mod = AGENT_MOD[current_agent]
	var low_rate  = mod[0]
	var mid_rate  = mod[1]
	var high_rate = mod[2]
	var low_depth  = mod[3]
	var mid_depth  = mod[4]
	var high_depth = mod[5]
	
	var phase_inc_low  = low_rate  / sample_rate
	var phase_inc_mid  = mid_rate  / sample_rate
	var phase_inc_high = high_rate / sample_rate
	
	for i in range(playback_low.get_frames_available()):
		phase_low = fmod(phase_low + phase_inc_low, 1.0)
		var mod_low = 1.0 - low_depth + low_depth * sin(phase_low * TAU)
		playback_low.push_frame(Vector2.ONE * _pink_noise_low() * mod_low)
	
	for i in range(playback_mid.get_frames_available()):
		phase_mid = fmod(phase_mid + phase_inc_mid, 1.0)
		var mod_mid = 1.0 - mid_depth + mid_depth * sin(phase_mid * TAU)
		playback_mid.push_frame(Vector2.ONE * _pink_noise_mid() * mod_mid)
	
	for i in range(playback_high.get_frames_available()):
		phase_high = fmod(phase_high + phase_inc_high, 1.0)
		var mod_high = 1.0 - high_depth + high_depth * sin(phase_high * TAU)
		# White noise for high layer
		var white = randf_range(-1.0, 1.0) * 0.15
		playback_high.push_frame(Vector2.ONE * white * mod_high)

func _pink_noise_low() -> float:
	var white = randf_range(-1.0, 1.0)
	b0_l = 0.99886 * b0_l + white * 0.0555179
	b1_l = 0.99332 * b1_l + white * 0.0750759
	b2_l = 0.96900 * b2_l + white * 0.1538520
	return (b0_l + b1_l + b2_l + white * 0.5362) * 0.08

func _pink_noise_mid() -> float:
	var white = randf_range(-1.0, 1.0)
	b0_m = 0.99886 * b0_m + white * 0.0555179
	b1_m = 0.99332 * b1_m + white * 0.0750759
	b2_m = 0.96900 * b2_m + white * 0.1538520
	return (b0_m + b1_m + b2_m + white * 0.5362) * 0.08

func _pink_noise_high() -> float:
	var white = randf_range(-1.0, 1.0)
	b0_h = 0.99886 * b0_h + white * 0.0555179
	b1_h = 0.99332 * b1_h + white * 0.0750759
	b2_h = 0.96900 * b2_h + white * 0.1538520
	return (b0_h + b1_h + b2_h + white * 0.5362) * 0.08

func start_hose():
	is_firing = true
	player_low.play()
	player_mid.play()
	player_high.play()
	playback_low = player_low.get_stream_playback()
	playback_mid = player_mid.get_stream_playback()
	playback_high = player_high.get_stream_playback()

func stop_hose():
	is_firing = false
	playback_low.get_frames_available()
	playback_mid.get_frames_available()
	player_low.stop()
	player_mid.stop()
	player_high.stop()

func set_agent(agent: int):
	current_agent = agent
	_update_bus_effects()

func _update_bus_effects():
	var eq_low = AudioServer.get_bus_effect(AudioServer.get_bus_index("HoseLow"), 1)
	var eq_mid = AudioServer.get_bus_effect(AudioServer.get_bus_index("HoseMid"), 1)
	var eq_high = AudioServer.get_bus_effect(AudioServer.get_bus_index("HoseHigh"), 1)
	
	var bands = AGENT_EQ[current_agent]
	for i in 10:
		eq_low.set_band_gain_db(i, bands["low"][i])
		eq_mid.set_band_gain_db(i, bands["mid"][i])
		eq_high.set_band_gain_db(i, bands["high"][i])
