extends CanvasLayer

signal finished
@export var tutorial_data: TutorialData

@onready var timer = $Timer
@onready var animation = $AnimationPlayer
@onready var label_container = $Control/PanelContainer/MarginContainer

var current_index = 0
var accept_input = false

func _ready() -> void:
	if (tutorial_data):
		if tutorial_data.text:	
			_update_label()			
			timer.start()
	else:
		animation.play("fade_out")

func _process(_delta: float) -> void:
	if !accept_input: return
	if !_check_input(): return
	
	accept_input = false
	current_index += 1
		
	if current_index == tutorial_data.text.size(): 
		animation.play("fade_out")
		timer.start()
	else:
		_update_label()
		timer.start()
		
func _update_label():
	label_container.visible = false
	if label_container.get_child_count() > 0:	
		for child in label_container.get_children():
			child.free()
	var label = ButtonPromptLabel.new()
	label.text = tutorial_data.text[current_index]
	label_container.add_child(label)
	label_container.visible = true
	
func _check_input() -> bool:
	var input := tutorial_data.inputs[current_index]
	if !input.contains(','): return Input.is_action_pressed(input)
	
	var inputs = input.split(',')
	for i in inputs:
		if Input.is_action_pressed(i): return true
	
	return false

func _on_timeout():
	if current_index == tutorial_data.text.size(): finished.emit()
	else: accept_input = true
