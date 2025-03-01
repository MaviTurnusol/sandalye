extends State

@export var speed := 150.0
var input := Vector2.ZERO : set = set_direction

func set_direction(value):
	if input.x > 0 && value.x <= 0:
		grandfather.playAnimationFullBody("turn")
	if input.x < 0 && value.x >= 0:
		grandfather.playAnimationFullBody("turn")
	if value.x == 0 && input.x != 0:
		grandfather.playAnimationConsequently("turnBackwards", "idle")
	if value.x != 0 && input.x == 0:
		grandfather.playAnimationConsequently("turn", "walk")
	input = value
	pass
func _ready():
	super._ready()
	conditions.append(grandfather.is_on_floor)
	calls.append(func(): return Input.is_action_pressed("ui_right"))
	calls.append(func(): return Input.is_action_pressed("ui_left"))
	pass

func Enter():
	grandfather.playAnimationConsequently("turn", "walk")
	endAnim = "turnBackwards"
	pass
func Physics_Update(_delta):
	input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
	if input.x != 0:
		grandfather.velocity.x = lerp(grandfather.velocity.x, input.x * speed, 0.1)
	else:
		grandfather.velocity.x = lerp(grandfather.velocity.x, 0.0, 0.2)
	if input.x < 0:
		grandfather.TurnSprites("left")
	elif input.x > 0:
		grandfather.TurnSprites("right")
	grandfather.move_and_slide()
	pass
