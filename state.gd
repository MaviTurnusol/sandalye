extends Node
class_name State

var passive = false
var grandfather = null
var conditions = []
var blacklist = []
var calls = []
var machine
var transitionAnimations = {}
signal transitioned
	
func _ready():
	grandfather = get_parent().get_parent()
	pass

func Physics_Update(_delta: float):
	pass

func Update(_delta: float):
	pass

func Enter():
	pass

func Exit():
	pass

func CanTransition():
	#if !exitAnimationDone:
		#return false

	if machine.currentState.name in blacklist:
		return false
		
	for condition in conditions:
		if condition is Callable and not condition.call():
			return false
		if condition is bool and !condition:
			return false
			
	if calls.is_empty():
		return true
	
	for call in calls:
		if call is Callable and call.call():
			return true
		if call is bool and call:
			return true
	
	return false

func boolChecker(boolean):
	if boolean:
		return true
	else:
		return false
