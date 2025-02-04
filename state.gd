extends Node
class_name State

var passive = false
func _ready():
	get_parent().currentState = self
	pass

func Update():
	pass

func Enter():
	pass

func Exit():
	pass
