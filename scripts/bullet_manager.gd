extends Node2D

@onready var AmmoData = ammo_data

func _on_player_fired_bullet(bullet, bullet_position, bullet_direction, bullet_type, source):
	var config = AmmoData.get_config(bullet_type)
	
	for i in int(config["projectiles"]):
		var b = bullet.duplicate()
		b.position = bullet_position
		b.direction = _apply_spread(bullet_direction, config["spread"])
		b.speed = config["speed"]
		b.lifetime = config["lifetime"]
		b.FRICTION = config["friction"]
		b.damage = b.damage / int(config["projectiles"])
		b.source = source
		b.ammo_type = bullet_type
		add_child(b)

func _apply_spread(direction: Vector2, spread_degrees: float):
	if spread_degrees == 0.0:
		return direction
	var spread_rad = deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	return direction.rotated(spread_rad)
