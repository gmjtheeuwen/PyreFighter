extends AttackComponent
class_name FireParticle

var speed: float
var range: float
var origin: Vector2

func _ready() -> void:
	global_position = origin

func _process(delta: float) -> void:
	global_position += speed * direction * delta
	
	if (global_position - origin).length() > range:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("environment"):
		queue_free()
	elif body.is_in_group("player"):
		body._on_hit(damage)
		queue_free()
