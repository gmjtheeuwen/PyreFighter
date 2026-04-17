extends CanvasLayer

signal finished
@export var tutorial_data: TutorialData

@onready var timer = $Timer
@onready var animation = $AnimationPlayer
@onready var label_container = $Control/PanelContainer/MarginContainer
@onready var label_scene = preload("res://scenes/button_prompt_label.tscn")

var current_index = 0
var accept_input = false

func _ready() -> void:
	if (tutorial_data):
		if tutorial_data.text:	
			_update_label(tutorial_data.text[0])
			timer.start()
	else:
		animation.play("fade_out")

func _process(_delta: float) -> void:
	if !accept_input: return
	if !_check_input(): return
	
	accept_input = false
	current_index += 1
		
	if current_index == tutorial_data.text.size():
		_update_label(tutorial_data.final_text)
		finished.emit()
		timer.start(3)
	else:
		_update_label(tutorial_data.text[current_index])
		timer.start()
		
func _update_label(text: String):
	label_container.visible = false
	for child in label_container.get_children(true):
		label_container.remove_child(child)
	var label = label_scene.instantiate()
	label.text = text
	label_container.add_child(label)
	label_container.set_deferred("visible", true)
	
func _check_input() -> bool:
	if current_index >= tutorial_data.inputs.size(): return Input.is_anything_pressed()
	var input := tutorial_data.inputs[current_index]
	if !input.contains(','): return Input.is_action_pressed(input)
	
	var inputs = input.split(',')
	for i in inputs:
		if Input.is_action_pressed(i): return true
	
	return false

func _on_timeout():
	if current_index == tutorial_data.text.size():
		animation.play("fade_out")
	else:
		accept_input = true
