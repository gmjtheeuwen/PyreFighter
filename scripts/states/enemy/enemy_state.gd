extends State
class_name EnemyState

const IDLE = "idle"
const CHASE = "chase"
const PATROL = "patrol"
const KNOCKED = "knocked"

var enemy: Enemy

func _ready():
	await owner.ready
	assert(owner is Enemy, "EnemyState must be a child of an Enemy")
	enemy = owner

func on_hit(_attack: AttackComponent):
	pass
