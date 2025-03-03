extends State

@export var walkSpeed := 100.0
@export var runSpeed := 200.0
var speed = 0
var input := Vector2.ZERO : set = set_direction
var playerVelocity : Vector2 : set = set_vel

func set_direction(value):
	input = value
	pass

func set_vel(value):
	if grandfather.currentAnim != "turnBackwards":
		if abs(playerVelocity.x) > 20 && abs(value.x) <= 20:
			grandfather.playAnimationFullBody("turn")
	playerVelocity = value
func _ready():
	super._ready()
	transitionAnimations["idle"] = "turnBackwards"
	speed = walkSpeed
	conditions.append(grandfather.is_on_floor)
	calls.append(func(): return Input.is_action_pressed("ui_right"))
	calls.append(func(): return Input.is_action_pressed("ui_left"))
	pass

func Enter():
	grandfather.playAnimationConsequtively("turn", "walk")
	pass
func Physics_Update(_delta):
	playerVelocity = grandfather.velocity
	input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
	if input.x != 0:
		if Input.is_action_pressed("ui_accept"):
			grandfather.playAnimationFullBody("run")
			grandfather.velocity.x = lerp(grandfather.velocity.x, input.x * runSpeed, 0.1)
		else:
			if grandfather.currentAnim != "turn":
				grandfather.playAnimationFullBody("walk")
			grandfather.velocity.x = lerp(grandfather.velocity.x, input.x * walkSpeed, 0.1)
	else:
		grandfather.playAnimationConsequtively("turnBackwards", "walk")
		grandfather.velocity.x = lerp(grandfather.velocity.x, 0.0, 0.2)
	if input.x < 0:
		grandfather.TurnSprites("left")
	elif input.x > 0:
		grandfather.TurnSprites("right")
	grandfather.move_and_slide()
	pass
