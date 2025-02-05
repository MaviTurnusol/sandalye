extends Node

signal starter
var currentState : State : set = setState

func setState(value):
	if currentState == value:
		return
	if currentState:
		currentState.Exit()
	value.Enter()
	currentState = value

func _ready():
	pass # Replace with function body.


func _process(delta):
	for child in get_children():
		if child is State:
			child.machine = self
			if get_parent():
				child.father = get_parent()
			if child.passive || child == currentState:
				child.Update(delta)
	pass
