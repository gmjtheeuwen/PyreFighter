extends EnemyState

func enter(_data := {}):
	enemy.velocity = Vector2.ZERO

func update(_delta: float):
	if enemy.raycast.get_collider() is Player:
		finished.emit("chase")

func on_hit(attack: AttackComponent):
	super(attack)
	if attack.knockback > 0:
		finished.emit("knocked", {"direction": attack.direction, "knockback_force": attack.knockback})
