extends CharacterBody2D
class_name Enemy

@export var stats : EnemyStats
var cloned_stats: EnemyStats

@export var MIN_KNOCKBACK_SPEED: float = 8.0

var has_line_of_sight := false
var invincible := false

@onready var state_machine = $StateMachine
@onready var health_component = $HealthComponent
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitflash = $AnimatedSprite2D/HitFlash
@onready var timer = $InvincibilityTimer
@onready var explosion_emitter: GPUParticles2D = $VFX/ExplosionEmitter
@onready var raycast: RayCast2D = $RayCast2D

@onready var hurt_player = $enemy_sfx/NoiseHurt
@onready var death_player = $enemy_sfx/NoiseDeath

func _ready() -> void:
	cloned_stats = stats.duplicate()
	health_component.MAX_HEALTH = cloned_stats.max_health
	health_component.health = health_component.MAX_HEALTH
	
	var at = AtlasTexture.new()
	at.atlas = cloned_stats.sprite_sheet
	var animation_name = "idle_" + Flame.FuelType.keys()[cloned_stats.fuel_type]
	if !sprite.sprite_frames.has_animation(animation_name):
		sprite.sprite_frames.add_animation(animation_name)
		for i in range(0,at.atlas.get_width()/at.atlas.get_height()):
			var temp_atlas := AtlasTexture.new()
			temp_atlas.atlas = at.atlas
			temp_atlas.filter_clip = true
			temp_atlas.region = Rect2(i*at.atlas.get_height(),0,at.atlas.get_height(),at.atlas.get_height())
			sprite.sprite_frames.add_frame(animation_name, temp_atlas)
	sprite.play(animation_name)

func _on_hit(attack: AttackComponent):
	if invincible: return
	if state_machine.state is EnemyState:
		state_machine.state.on_hit(attack)
	health_component.damage(attack.damage)
	cloned_stats.resolve_effects(attack.attack_type, attack.source, self)
	hitflash.play("hit_flash")
	invincible = true	

func _on_body_entered(body: Node2D):
	if body is not Player: return
	var attack = AttackComponent.new()
	attack.damage = cloned_stats.damage
	attack.direction = raycast.target_position.normalized()
	attack.source = self
	attack.attack_type = AttackComponent.AmmoType.NONE
	attack.knockback = cloned_stats.knockback
	body.on_hit(attack)

func _process(_delta: float) -> void:
	var player: Player = get_tree().current_scene.find_child("Player")
	if not player: return
	raycast.target_position = player.global_position - global_position
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func invincibility_ended(anim_name: StringName):
	invincible = false
	if health_component.health > 0:
		var temp_player = AudioStreamPlayer.new()
		get_tree().current_scene.add_child(temp_player)
		temp_player.stream = hurt_player.stream
		temp_player.pitch_scale = randf_range(0.9, 1.1)
		temp_player.volume_db = hurt_player.volume_db
		temp_player.bus = hurt_player.bus
		temp_player.play()
		temp_player.finished.connect(temp_player.queue_free)

func _on_death():
	hurt_player.stop()
	var temp_player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(temp_player)
	temp_player.stream = death_player.stream
	temp_player.pitch_scale = randf_range(0.9, 1.1)
	temp_player.volume_db = death_player.volume_db
	temp_player.bus = death_player.bus
	temp_player.play()
	temp_player.finished.connect(temp_player.queue_free)
	queue_free()
