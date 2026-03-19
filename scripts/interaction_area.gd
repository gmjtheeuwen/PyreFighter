extends Area2D
signal interacted

var player: Node2D = null
@onready var label = $Label

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body

func on_body_exited(body: Node2D):
	if body == player:
		player = null
		label.text = "Interact"


func _process(_delta: float) -> void:
	if player == null: 
		label.visible = false
		return
	label.visible = true
	
	if Input.is_action_just_pressed("interact"):
		label.text = "Player interacted"
