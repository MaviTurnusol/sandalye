extends CharacterBody2D

var speed = 130.0
var jumpvel = -400.0

enum STATES {WALK, RUN, ROLL, IDLE}
var state = STATES.IDLE : set = set_state

@onready var anima = $anima

func set_state(value):
	if state == value:
		return
	if value == STATES.ROLL:
		if Input.is_action_pressed("right"):
			velocity.x = 300
		if Input.is_action_pressed("left"):
			velocity.x = -300
		anima.play("roll")
	state = value
	
func _physics_process(delta):
	
	match state:
		STATES.IDLE:
			if anima.animation == "roll":
				anima.play("idle")
			if velocity.x < 50 && velocity.x > -50:
				anima.play("idle")
			move_and_slide()
		STATES.RUN:
			anima.play("run")
			move_and_slide()
		STATES.WALK:
			if abs(velocity.x) <= speed * 1.35:
				anima.play("walk")
			move_and_slide()
		STATES.ROLL:
			if anima.animation == "roll" && anima.frame == 4:
				velocity.x = lerp(velocity.x, velocity.x/30, 0.1)
			if anima.animation == "roll" && anima.frame >= 10:
				state = STATES.IDLE
			move_and_slide()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
	if state != STATES.ROLL:
		if input.x != 0:
			if Input.is_action_pressed("run"):
				velocity.x = lerp(velocity.x, input.x * speed * 1.65, 0.1)
				if is_on_floor(): state = STATES.RUN
			else:
				velocity.x = lerp(velocity.x, input.x * speed, 0.1)
				if is_on_floor(): state = STATES.WALK
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			if is_on_floor(): state = STATES.IDLE
	
	if state != STATES.ROLL:
		if Input.is_action_pressed("left"):
			anima.flip_h = true
		elif Input.is_action_pressed("right"):
			anima.flip_h = false
	
	if Input.is_action_just_pressed("space"):
		state = STATES.ROLL
