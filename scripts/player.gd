extends CharacterBody2D	
class_name Player

signal fired_bullet(bullet: Bullet, position: Vector2, direction: Vector2, source: Node2D)
signal used_equipment(direction)
signal ammo_changed(ammo_type)

@export var has_control: bool

var WALKSPEED: float = 256.0
var JOYSTICK_SENSITIVITY = 0.4
var direction:= Vector2.ZERO
var aim_direction:= Vector2.RIGHT

var knocked = false
@export var knockback_friction : float
@export var MIN_KNOCKBACK_SPEED : float

var fire_delay = 0.018
var time_since_last_shot = 0.0
var ammo_type := AttackComponent.AmmoType.WATER
var current_ammo = 1

@export var health_component: HealthComponent

var bullet_scene = preload("res://scenes/bullet.tscn")

var ammo_list = AttackComponent.AmmoType.values()
@onready var gun = $Gun
var gun_position: Vector2
var last_direction: String = "down"
var show_gun: bool = true

@onready var sprite = $AnimatedSprite2D

var invincible = false
@onready var hitflash = $AnimatedSprite2D/HitFlash

@onready var hose_audio = $HoseAudio
@onready var player_audio = $player_sfx

var ammo_switch_cooldown := 0.0
const SCROLL_COOLDOWN := 0.15

@onready var pause_menu = $CanvasLayer/Control/PauseMenu
@onready var hud = $CanvasLayer

func _ready() -> void:
	set_process_input(has_control)
	gun_position = gun.position
	
	hitflash.play("RESET")
	get_node("CanvasLayer").visible = true
	ammo_changed.emit(ammo_type)

func _process(delta: float) -> void:
	if ammo_switch_cooldown > 0.0:
		ammo_switch_cooldown -= delta
	
	if health_component.health <= 0:
		_on_death()
		return
		
	if !is_processing_input(): return
	var joypads := Input.get_connected_joypads()
	if joypads.size() > 0:
		handle_controller_input(joypads)
	else:
		handle_keyboard_input()
		
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot > fire_delay:
		shoot()
		time_since_last_shot = 0.0
		if not hose_audio.is_firing:
			hose_audio.start_hose()
	
	if Input.is_action_just_released("shoot"):
		hose_audio.stop_hose()
	
	if Input.is_action_just_pressed("equipment"):
		use_equipment()
		
	if Input.is_action_just_pressed("ui_page_right"):
		_switch_ammo(1)
	
	if Input.is_action_just_pressed("ui_page_left"):
		_switch_ammo(-1)
		
	if Input.is_action_just_pressed("pause"):
		pause()
	
	if direction.y > 0.2:
		sprite.play("walk_down")
		last_direction = "down"
		show_gun = true
		gun_position = Vector2.ZERO
	elif direction.y < -0.2:
		sprite.play("walk_up")
		last_direction = "up"
		show_gun = false
	elif direction.x > 0.2:
		sprite.play("walk_right")
		last_direction = "right"
		show_gun = true
		gun_position = Vector2(2, 0)*sprite.scale.x
	elif direction.x < -0.2:
		sprite.play("walk_left")
		last_direction = "left"
		show_gun = true
		gun_position = Vector2(-2, 0)*sprite.scale.x
	else:
		sprite.play("idle_%s" % last_direction)
		
	if (gun):
		gun.position = gun_position
		gun.visible = show_gun

func _physics_process(delta: float) -> void:	
	if knocked:
		velocity = velocity.normalized() * (velocity.length()-knockback_friction*delta)
		if velocity.length() < MIN_KNOCKBACK_SPEED:
			knocked = false
	else: 
		velocity = direction * WALKSPEED
	move_and_slide()

func handle_controller_input(joypads: Array[int]) -> void:
	var primary_joypad = joypads[0]
	var move_input_x = Input.get_joy_axis(primary_joypad, JoyAxis.JOY_AXIS_LEFT_X)
	var move_input_y = Input.get_joy_axis(primary_joypad, JoyAxis.JOY_AXIS_LEFT_Y)
	
	if abs(move_input_x) >= JOYSTICK_SENSITIVITY:
		move_input_x = sign(move_input_x)
	else:
		move_input_x = 0
	
	if abs(move_input_y) >= JOYSTICK_SENSITIVITY:
		move_input_y = sign(move_input_y)
	else:
		move_input_y = 0
	
	direction = Vector2(move_input_x, move_input_y)
	
	var aim_input_x = Input.get_joy_axis(primary_joypad, JoyAxis.JOY_AXIS_RIGHT_X)
	var aim_input_y = Input.get_joy_axis(primary_joypad, JoyAxis.JOY_AXIS_RIGHT_Y)
	
	if (abs(aim_input_x) >= JOYSTICK_SENSITIVITY || abs(aim_input_y) >= JOYSTICK_SENSITIVITY):	
		aim_direction = Vector2(aim_input_x, aim_input_y).normalized()

func handle_keyboard_input() -> void:
	var move_input_x = Input.get_axis("left", "right")
	var move_input_y = Input.get_axis("up", "down")
	
	direction = Vector2(move_input_x, move_input_y).normalized()
	
	var mouse_position = get_viewport().get_mouse_position()
	var rect = get_viewport_rect()
	var aim_x = mouse_position.x - rect.size.x/2
	var aim_y = mouse_position.y - rect.size.y/2
	aim_direction = Vector2(aim_x, aim_y).normalized()

func on_hit(attack: AttackComponent):
	if invincible: return
	player_audio.play_hurt()
	hitflash.play("hit_flash")	
	invincible = true
	health_component.damage(attack.damage)
	
	if attack.knockback > 0:
		knocked = true
		velocity = attack.direction * attack.knockback
	
func _on_death():
	var level = get_parent()
	if level != null:
		MissionManager.call_deferred("on_mission_fail", get_parent().mission)
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
	
func invincibility_ended(anim_name: StringName):		
	invincible = false

func shoot():
	if knocked or bullet_scene == null: return
	var bullet_instance = bullet_scene.instantiate()
	var bullet_position = position + aim_direction * 16
	bullet_instance.attack_type = ammo_type
	bullet_instance.source = self
	
	emit_signal("fired_bullet", bullet_instance, bullet_position, aim_direction)
	
	if not hose_audio.is_firing:
		hose_audio.start_hose()
	
func use_equipment():
	emit_signal("used_equipment", aim_direction)
	
func pause():
	pause_menu.show()
	Engine.time_scale = 0
	
func unpause():
	pause_menu.hide()
	Engine.time_scale = 1
	
func give_control():
	set_process_input(true)

func take_control():
	set_process_input(false)

func _switch_ammo(direction: int):
	var next = (current_ammo + direction + ammo_list.size()) % ammo_list.size()
	while not InventoryManager.inventory_data.unlocked_ammo[ammo_list[next]]:
		next = (next + direction + ammo_list.size()) % ammo_list.size()
	current_ammo = next
	ammo_type = ammo_list[current_ammo]
	emit_signal("ammo_changed", ammo_type)
	
	hose_audio.set_agent(current_ammo)
