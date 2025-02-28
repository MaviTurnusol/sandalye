extends Node

@export var initialState : State
var currentState : State
var nextState : State

var states : Dictionary = {}
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_state_transition)
			child.machine = self
	
	if initialState:
		initialState.Enter()
		currentState = initialState
	
	if get_parent().has_signal("exitAnimEnd"):
		get_parent().exitAnimEnd.connect(ExitAnimationFinished)

func _process(delta):
	if currentState:
		currentState.Update(delta)
	
	for state in get_children():
		if state is State:
			if state != currentState && state.CanTransition():
				switch_state(state)

func _physics_process(delta):
	if currentState:
		currentState.Physics_Update(delta)

func switch_state(newState):
	if currentState:
		if currentState.endAnim:
			get_parent().PlayExitAnimation(currentState.endAnim)
			nextState = newState
			return
		else:
			currentState.Exit()
	currentState = newState
	currentState.Enter()

func on_state_transition(state, newStateName):
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.Exit()
	
	newState.Enter()
	currentState = newState

func ExitAnimationFinished():
	if nextState:
		currentState = nextState
		nextState.Enter()
