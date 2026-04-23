extends EnemyState

var target: Vector2

func enter(data:= {}):
	if not data["target"]: 
		finished.emit("idle")
	target = data["target"]
	
func physics_update(_delta: float):
	if enemy.position.distance_to(target) < 4:
		finished.emit("idle")
	if enemy.raycast.get_collider() is Player:
		finished.emit("chase")
	enemy.velocity = target.normalized() * enemy.cloned_stats.max_speed
