extends Node2D

@export var player: CharacterBody2D

func _process(_delta: float) -> void:	
	look_at(player.position + player.aim_direction)
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1


func _on_player_change_ribbon(ammo_type: Variant) -> void:
	if ammo_type == AttackComponent.AmmoType.WATER:
		$AnimatedSprite2D.frame = 0
	elif ammo_type == AttackComponent.AmmoType.FOAM:
		$AnimatedSprite2D.frame = 1
	elif ammo_type == AttackComponent.AmmoType.POWDER:
		$AnimatedSprite2D.frame = 2
	elif ammo_type == AttackComponent.AmmoType.CARBONDIOXIDE:
		$AnimatedSprite2D.frame = 3
