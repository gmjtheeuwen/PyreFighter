extends CharacterBody2D	

signal fired_bullet(bullet, position, direction)

var WALKSPEED: float = 192.0
var JOYSTICK_SENSITIVITY = 0.4
var direction:= Vector2(0,0)
var aim_direction:= Vector2(0,0)

var fire_delay = 0.05
var time_since_last_shot = 0.0


@export var Bullet: PackedScene

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var joypads := Input.get_connected_joypads()
	if Input.get_connected_joypads().size() > 0:
		handle_controller_input(joypads)
	else:
		handle_keyboard_input()
		
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot > fire_delay:
		shoot()
		time_since_last_shot = 0.0

func _physics_process(delta: float) -> void:	
	velocity = delta * direction * WALKSPEED
	move_and_collide(velocity)


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
	

func shoot():
	var bullet_instance = Bullet.instantiate()
	
	emit_signal("fired_bullet", bullet_instance, position, aim_direction)

func handle_hit():
	print("player hit")
