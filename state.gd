extends Node
class_name State

var passive = false
var father : Node = null : set = setFather
var machine

func setFather(value):
	father = value
	Enter()
	
func _ready():
	get_parent().currentState = self
	pass

func Update(delta):
	pass

func Enter():
	pass

func Exit():
	pass
