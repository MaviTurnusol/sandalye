extends State

func _ready():
	grandfather = get_parent().get_parent()
	conditions.append(func(): return !Input.is_action_pressed("ui_right"))
	conditions.append(func(): return !Input.is_action_pressed("ui_left"))

func Physics_Update(delta):
	grandfather.move_and_slide()
	if !grandfather.is_on_floor():
		grandfather.velocity.y += delta*300.0
	grandfather.velocity.x = lerp(grandfather.velocity.x, 0.0, 0.1)
	
	#if Input.is_action_pressed("ui_left")
func Enter():
	if grandfather:
		grandfather.playAnimationFullBody("idle")
