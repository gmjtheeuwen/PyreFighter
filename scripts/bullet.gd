extends AttackComponent

var MAX_SPEED : float = 800
var FRICTION : float = 0.8
const MIN_VELOCTIY := 64.0
@onready var sprite = $Sprite2D

var speed = MAX_SPEED
var lifetime: float = 2.0

const AMMO_COLOR_MAP = {
	AttackComponent.AmmoType.WATER: Color("#639bff"),
	AttackComponent.AmmoType.FOAM: Color("#FFFDD0"),
	AttackComponent.AmmoType.POWDER: Color("#F0EDE0"),
	AttackComponent.AmmoType.CARBONDIOXIDE: Color("#7DD4E8")
}

var ammo_type:= AttackComponent.AmmoType.WATER

func _ready() -> void:
	var timer = Timer.new()
	sprite.self_modulate = AMMO_COLOR_MAP[ammo_type]
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO: return
	
	speed *= (1-FRICTION*delta)
	var velocity = direction * speed
	
	if (velocity.length() < MIN_VELOCTIY):	queue_free()
	
	global_position += velocity * delta
	scale = Vector2(1,1)*(6.4+log(2/speed))
	
func _on_body_entered(body: Node2D):
	if (body.is_in_group("environment")):
		_resolve()
	elif body.is_in_group("flame"):
		body._on_hit(self)
		_resolve()
	elif (body.is_in_group("enemy")):
		body._on_hit(self)
		_resolve()

func _on_area_entered(area: Area2D):
	var body = area.get_parent()
	_on_body_entered(body)

func _resolve():
	queue_free()

func _on_timer_timeout():
	queue_free()
