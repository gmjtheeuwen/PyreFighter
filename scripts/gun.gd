extends Node2D

@export var player: CharacterBody2D

func _process(_delta: float) -> void:	
	look_at(global_position + player.aim_direction)
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
