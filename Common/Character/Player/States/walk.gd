extends State
@export var speed := 150.0
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
	var input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
	if input.x != 0:
		grandfather.velocity.x = lerp(grandfather.velocity.x, input.x * speed, 0.1)
	if input.x < 0:
		grandfather.TurnSprites("left")
	elif input.x > 0:
		grandfather.TurnSprites("right")
	grandfather.move_and_slide()
	pass
