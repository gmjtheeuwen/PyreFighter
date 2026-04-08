extends Node2D

func _on_player_fired_bullet(bullet, bullet_position, bullet_direction, source):
	add_child(bullet)
	bullet.global_position = bullet_position
	bullet.direction = bullet_direction
	bullet.source = source
