extends AttackComponent

const MAX_SPEED := 320.0
const FRICTION := 0.6
const MIN_VELOCTIY := 4.0
@onready var sprite = $Sprite2D

var speed = MAX_SPEED
var direction := Vector2.ZERO

const AMMO_COLOR_MAP = {
	AttackComponent.AmmoType.WATER: Color("639bff"),
	AttackComponent.AmmoType.FOAM: Color("#D4EEF7"),
	AttackComponent.AmmoType.POWDER: Color("#F0EDE0"),
	AttackComponent.AmmoType.CARBONDIOXIDE: Color("#7DD4E8")
}

var ammo_type:= AttackComponent.AmmoType.WATER

func _ready() -> void:
	sprite.self_modulate = AMMO_COLOR_MAP[ammo_type]

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO: return
	
	speed *= (1-FRICTION*delta)
	var velocity = direction * speed
	
	if (velocity.length() < MIN_VELOCTIY):
		queue_free()
	
	position += velocity * delta
	
func _on_body_entered(body: Node2D):
	if (body.is_in_group("environment")):
		_resolve()
	elif (body.is_in_group("enemy")):
		body._on_hit(self)
		_resolve()

func _resolve():
	queue_free()
