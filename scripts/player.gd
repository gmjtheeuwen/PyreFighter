extends CharacterBody2D	
class_name Player

signal fired_bullet(bullet, position, direction, source, bullet_type)
signal used_equipment(direction)
signal ammo_changed(ammo_type)
signal change_ribbon(ammo_type)

@export var has_control: bool

var WALKSPEED: float = 224.0
var JOYSTICK_SENSITIVITY = 0.4
var direction:= Vector2.ZERO
var aim_direction:= Vector2.RIGHT

var is_knock_backed := false
@export var knockback_friction : float
@export var MIN_KNOCKBACK_SPEED : float

var fire_delay = 0.018
var time_since_last_shot = 0.0
var ammo_type := AttackComponent.AmmoType.WATER
var current_ammo = 1

@export var Bullet: PackedScene
@export var health_component: HealthComponent

var bullet_scene = preload("res://scenes/bullet.tscn")

var ammo_list = AttackComponent.AmmoType.values()
@onready var hitflash = $AnimatedSprite2D/HitFlash

func _ready() -> void:
	set_process_input(has_control)

func _process(delta: float) -> void:
	if health_component.health <= 0:
		_on_death()
		return
		
	if !is_processing_input(): return
	var joypads := Input.get_connected_joypads()
	if Input.get_connected_joypads().size() > 0:
		handle_controller_input(joypads)
	else:
		handle_keyboard_input()
		
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot > fire_delay:
		shoot()
		time_since_last_shot = 0.0
	
	if Input.is_action_just_pressed("equipment"):
		use_equipment()
		
	if Input.is_action_just_pressed("ui_page_right"):
		var next = (current_ammo + 1) % ammo_list.size()
		while not InventoryManager.inventory_data.unlocked_ammo[ammo_list[next]]:
			next = (next + 1) % ammo_list.size()
		current_ammo = next
		ammo_type = ammo_list[current_ammo]
		emit_signal("ammo_changed", ammo_type)
		emit_signal("change_ribbon", ammo_type)
	
	if Input.is_action_just_pressed("ui_page_left"):
		var next = (current_ammo - 1 + ammo_list.size()) % ammo_list.size()
		while not InventoryManager.inventory_data.unlocked_ammo[ammo_list[next]]:
			next = (next - 1 + ammo_list.size()) % ammo_list.size()
		current_ammo = next
		ammo_type = ammo_list[current_ammo]
		emit_signal("ammo_changed", ammo_type)
		emit_signal("change_ribbon", ammo_type)

func _physics_process(delta: float) -> void:	
	if is_knock_backed:
		velocity = velocity.normalized() * (velocity.length()-knockback_friction*delta)
		if velocity.length() < MIN_KNOCKBACK_SPEED:
			is_knock_backed = false
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

func _on_hit(damage: float):
	hitflash.play("hit_flash")
	health_component.damage(damage)
	
func _on_death():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func shoot():
	if Bullet == null: return
	var bullet_instance = Bullet.instantiate()
	var bullet_position = position + aim_direction * 16
	bullet_instance.ammo_type = ammo_type
	
	emit_signal("fired_bullet", bullet_instance, bullet_position, aim_direction, ammo_type, self)
	
func use_equipment():
	emit_signal("used_equipment", aim_direction)

func handle_hit():
	pass


func _on_ammo_changed(ammo_type: Variant) -> void:
	pass # Replace with function body.
func give_control():
	set_process_input(true)

func take_control():
	set_process_input(false)
