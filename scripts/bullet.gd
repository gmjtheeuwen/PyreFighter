extends Area2D

const MAX_SPEED := 256.0
const FRICTION := 0.6
const MIN_VELOCTIY := 4.0

var speed = MAX_SPEED
var direction := Vector2.ZERO
var damage := 1.0

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO: return
	
	speed *= (1-FRICTION*delta)
	var velocity = direction * speed
	
	if (velocity.length() < MIN_VELOCTIY):
		queue_free()
	
	position += velocity * delta
	
func _on_bullet_body_entered(body: Node2D):
	if (body.is_in_group("environment")):
		queue_free()
	elif (body.is_in_group("enemy")):
		body.on_hit(self)
