extends State

var buttonPressed = false
var buttonHeld = false
var buttonTimer = 0.0

func _ready():
	grandfather = get_parent().get_parent()
	#conditions.append(func(): return !Input.is_action_pressed("ui_right"))
	#conditions.append(func(): return !Input.is_action_pressed("ui_left"))
	conditions.append(func(): return boolChecker(!buttonPressed))

func Physics_Update(delta):
	grandfather.move_and_slide()
	if !grandfather.is_on_floor():
		grandfather.velocity.y += delta*300.0
	grandfather.velocity.x = lerp(grandfather.velocity.x, 0.0, 0.1)

func _process(delta):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		buttonHeld = true
		buttonTimer = 0.0
	else:
		buttonHeld = false
	
	if !buttonHeld:
		buttonTimer += delta
	if buttonTimer > 0.2:
		buttonPressed = false
	else:
		buttonPressed = true

func Enter():
	if grandfather:
		grandfather.playAnimationFullBody("idle")

func _on_button_press_timer_timeout():
	buttonPressed = false
	pass # Replace with function body.
