extends Effect

@export var explosion_force: float
@export var explosion_range: float
@export var explosion_damage: float

func resolve(ammo_type: AttackComponent.AmmoType, attacker: Player, target: Enemy):
	if ammo_type == AttackComponent.AmmoType.WATER and !target.explosion_emitter.emitting:
		var distance = (attacker.position - target.position).length()
		if distance <= explosion_range:
			var attack = AttackComponent.new()
			attack.damage = explosion_damage
			attack.source = target
			attack.direction = (attacker.position - target.position).normalized()
			attack.knockback = explosion_force
			attacker.on_hit(attack)
		target.explosion_emitter.restart()
