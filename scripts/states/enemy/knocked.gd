extends EnemyState

func enter(data:= {}):
	if not data.get("direction") or not data.get("knockback_force"):
		finished.emit("idle")
		
	enemy.velocity = data["direction"] * data["knockback_force"]
	
func physics_update(delta: float):
	enemy.velocity = enemy.velocity.normalized() * (enemy.velocity.length()-enemy.cloned_stats.knockback_friction*delta)
	if enemy.velocity.length() < enemy.MIN_KNOCKBACK_SPEED:
		finished.emit("idle")
