extends AttackComponent

const MAX_SPEED := 800.0
const FRICTION := 0.8
const MIN_VELOCTIY := 16.0

var speed = MAX_SPEED

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
