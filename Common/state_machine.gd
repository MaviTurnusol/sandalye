extends Node

signal starter
var currentState : set = setState

func setState(value):
	if currentState == value:
		return
	currentState.Exit()
	value.Enter()
	currentState = value

func _ready():
	pass # Replace with function body.


func _process(delta):
	for child in get_children():
		if child is State:
			if child.passive || child == currentState:
				child.Update()
	pass
