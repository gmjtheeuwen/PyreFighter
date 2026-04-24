extends Node2D

@onready var ammo_data = AmmoData

func _on_player_fired_bullet(bullet: Bullet, bullet_position: Vector2, bullet_direction: Vector2):
	var config = ammo_data.get_config(bullet.attack_type)
	for i in range(config["projectiles"]):
		var b: Bullet = bullet.duplicate()
		b.position = bullet_position
		b.direction = _apply_spread(bullet_direction, config["spread"])
		b.speed = config["speed"]
		b.lifetime = config["lifetime"]
		b.FRICTION = config["friction"]
		b.damage = config["damage"] / config["projectiles"]
		b.knockback = config["knockback"]
		b.attack_type = bullet.attack_type
		b.source = bullet.source
		add_child(b)

func _apply_spread(direction: Vector2, spread_degrees: float):
	if spread_degrees == 0.0:
		return direction
	var spread_rad = deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	return direction.rotated(spread_rad)
