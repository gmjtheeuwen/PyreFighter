extends EnemyStats

@export var explosion_force: float
@export var explosion_range: float
@export var explosion_damage: float

func resolve_effects(ammo_type: AttackComponent.AmmoType, attacker:Player, target: Enemy):
	if ammo_type == AttackComponent.AmmoType.WATER and !target.explosion_emitter.emitting:
		var distance = (attacker.position - target.position).length()
		if distance <= explosion_range:
			attacker.velocity = (attacker.position - target.position).normalized() * explosion_force
			attacker.is_knock_backed = true
			attacker.health_component.damage(explosion_damage)
		target.explosion_emitter.restart()
