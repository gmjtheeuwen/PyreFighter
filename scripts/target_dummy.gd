class_name target_dummy
extends Enemy

var damage_log: Array = []
const WINDOW := 3.0

func _ready():
	cloned_stats = stats.duplicate()
	health_component.MAX_HEALTH = cloned_stats.max_health
	health_component.health = health_component.MAX_HEALTH

func _on_hit(attack: AttackComponent):
	health_component.damage(attack.damage)
	damage_log.append([Time.get_ticks_msec() / 1000.0, attack.damage])
	
	if attack.knockback > 0 && !is_knock_backed:
		velocity = attack.direction * attack.knockback
		cloned_stats.resolve_effects(attack.attack_type, attack.source, self)
		is_knock_backed = true
	
	timer.start()
	hitflash.play("hit_flash")

func _physics_process(delta: float) -> void:
	if is_knock_backed:
		velocity = velocity.normalized() * (velocity.length() - cloned_stats.knockback_friction * delta)
		if velocity.length() < MIN_KNOCKBACK_SPEED:
			is_knock_backed = false
	move_and_slide()
	
	var now = Time.get_ticks_msec() / 1000.0
	damage_log = damage_log.filter(func(e): return now - e[0] < WINDOW)
	var total = damage_log.reduce(func(acc, e): return acc + e[1], 0.0)
	$Label.text = "DPS: %.1f" % (total / WINDOW)

func _on_death():
	health_component.health = health_component.MAX_HEALTH
