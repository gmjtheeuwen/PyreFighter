extends CharacterBody2D
class_name Enemy

@export var stats : EnemyStats
var cloned_stats: EnemyStats

@export var MIN_KNOCKBACK_SPEED: float = 8.0

var is_knock_backed := false

@onready var health_component = $HealthComponent
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitflash = $AnimatedSprite2D/HitFlash
@onready var timer = $InvincibilityTimer
@onready var explosion_emitter: GPUParticles2D = $VFX/ExplosionEmitter

func _ready() -> void:
	cloned_stats = stats.duplicate()
	health_component.MAX_HEALTH = cloned_stats.max_health
	health_component.health = health_component.MAX_HEALTH
	
	var at = AtlasTexture.new()
	at.atlas = cloned_stats.sprite_sheet
	var animation_name = "idle_" + cloned_stats.type
	sprite.sprite_frames.add_animation(animation_name)
	for i in range(0,at.atlas.get_width()/at.atlas.get_height()):
		var temp_atlas := AtlasTexture.new()
		temp_atlas.atlas = at.atlas
		temp_atlas.filter_clip = true
		temp_atlas.region = Rect2(i*at.atlas.get_height(),0,at.atlas.get_height(),at.atlas.get_height())
		sprite.sprite_frames.add_frame(animation_name, temp_atlas)
	sprite.animation = animation_name
	sprite.play()
	

func _on_hit(attack: AttackComponent):
	health_component.damage(attack.damage)
	
	if attack.knockback > 0 && !is_knock_backed:
		velocity = attack.direction * attack.knockback
		is_knock_backed = true
		
	timer.start()
	hitflash.play("hit_flash")

	cloned_stats.resolve_effects(attack.attack_type, attack.source, self)
	
func _physics_process(delta: float) -> void:
	if is_knock_backed:
		velocity = velocity.normalized() * (velocity.length()-cloned_stats.knockback_friction*delta)
		if velocity.length() < MIN_KNOCKBACK_SPEED:
			is_knock_backed = false 
	move_and_slide()

func _on_death():
	get_parent().remove(self)
	queue_free()
