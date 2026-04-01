extends AttackComponent

const MAX_SPEED := 800.0
const FRICTION := 0.8
const MIN_VELOCTIY := 16.0

var speed = MAX_SPEED

var count = 0

func _init():
	pass

func _physics_process(delta: float) -> void:
	count += 1
	if direction == Vector2.ZERO: return
	
	speed *= (1-FRICTION*delta)
	var velocity = direction * speed
	
	if (velocity.length() < MIN_VELOCTIY):	queue_free()
	
	global_position += velocity * delta
	scale = Vector2(1,1)*(6.4+log(2/speed))
	
func _on_body_entered(body: Node2D):
	if (body.is_in_group("environment")):
		_resolve()
	elif (body.is_in_group("enemy")):
		body._on_hit(self)
		_resolve()

func _resolve():
	queue_free()
