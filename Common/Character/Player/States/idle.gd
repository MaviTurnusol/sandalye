extends State

func Update(delta):
	father.move_and_slide()
	if !father.is_on_floor():
		father.velocity.y += delta*300.0
	#if Input.is_action_pressed("ui_left")

func Enter():
	if father:
		father.playAnimationFullBody("idle")
