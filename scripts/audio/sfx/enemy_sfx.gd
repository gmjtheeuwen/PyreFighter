class_name enemy_sfx
extends Node2D

@onready var hurt_player = $NoiseHurt
@onready var death_player = $NoiseDeath

func play_hurt_sound():
	hurt_player.pitch_scale = randf_range(0.9, 1.1)
	hurt_player.play()

func play_death_sound():
	death_player.pitch_scale = randf_range(0.9, 1.1)
	death_player.play()
