extends EnemyState

var player: Player
	
func update(_delta: float):
	if enemy.raycast.get_collider() is not Player: 
		finished.emit("investigate", {"target": enemy.raycast.target_position})

func physics_update(delta: float):
	enemy.velocity = enemy.raycast.target_position.normalized() * enemy.cloned_stats.max_speed

func on_hit(attack: AttackComponent):
	super(attack)
	if attack.knockback > 0:
		finished.emit("knocked", {"direction": attack.direction, "knockback_force": attack.knockback})
