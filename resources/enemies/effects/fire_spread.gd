extends Effect

@export var fire_particle: PackedScene
@export var particle_count: int
@export var particle_speed: float
@export var spread_range: float
@export var damage: float

func resolve(ammo_type: AttackComponent.AmmoType, attacker: Player, target: Enemy):
	if ammo_type != AttackComponent.AmmoType.WATER: return
	if !fire_particle: return
	for i in range(particle_count):
		var instance = fire_particle.instantiate()
		if instance is not FireParticle: return
		
		instance = instance as FireParticle
		instance.origin = target.global_position
		instance.damage = damage
		instance.speed = particle_speed
		instance.range = spread_range
		instance.direction = Vector2.from_angle(randf()*2*PI)
		instance.fuel_type = target.cloned_stats.fuel_type
		target.get_parent().call_deferred("add_child", instance)
